{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.hyprland;
in
{
  imports = [ ];

  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      # Package + portal come from nixpkgs (matching the NixOS
      # programs.hyprland module) — no Hyprland flake input.
      configType = "lua";

      # Main config, managed by the home-manager hyprland module: it is
      # appended to the generated hyprland.lua (which also carries the
      # systemd activation hooks). Do NOT also deploy it via
      # xdg.configFile."hypr/hyprland.lua", the module owns that file.
      extraConfig = builtins.readFile ./hyprland.lua;
      systemd.enable = false;
    };

    # Bar as a systemd user unit bound to the graphical session
    # (uwsm-owned) instead of an exec in hyprland.lua, so it stops
    # cleanly with `uwsm stop`.
    programs.waybar = {
      enable = true;
      systemd.enable = true;
    };

    home.packages = [
      pkgs.hyprlock
      pkgs.hyprutils
      pkgs.hyprlauncher
    ];

    # Idle daemon as a systemd user unit bound to the graphical session.
    # Policy: 2.5min idle → dim/keyboard backlight off, 5min → lock,
    #         5.5min → display off, 10min → log out.
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # avoid pressing a key twice to turn the display on.
        };

        listener = [
          {
            timeout = 150; # 2.5min. Dim the monitor backlight (avoid 0 on OLED monitors).
            on-timeout = "brightnessctl -s set 5";
            on-resume = "brightnessctl -r"; # restore the monitor backlight.
          }
          {
            timeout = 150; # 2.5min. Turn off the keyboard backlight (no-op without rgb:kbd_backlight).
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn the keyboard backlight back on.
          }
          {
            timeout = 300; # 5min. Lock the screen when the timeout has passed.
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330; # 5.5min. Screen off when the timeout has passed.
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after the timeout fired.
          }
          {
            timeout = 600; # 10min. Log out if the session is still idle 5min after locking.
            on-timeout = "uwsm stop";
          }
        ];
      };
    };

    # Blue-light filter (replaces X11-only redshift): runs as a systemd
    # user service bound to the Hyprland session, config at hypr/hyprsunset.conf.
    services.hyprsunset = {
      enable = true;
      settings = {
        max-gamma = 150;
        profile = [
          {
            time = "7:30";
            identity = true;
          }
          {
            time = "21:00";
            temperature = 2500;
            gamma = 0.8;
          }
        ];
      };
    };

    # Wallpaper daemon as a systemd user unit bound to the graphical
    # session. Config is rendered from settings below into
    # hypr/hyprpaper.conf (equivalent to the previous static file).
    services.hyprpaper = {
      enable = true;
      settings = {
        wallpaper = {
          monitor = "";
          path = "$HOME/.config/hypr/green-mountains.jpg";
          fit_mode = "cover";
        };
      };
    };

    # Tray applet as a systemd user unit (requires tray.target, bound
    # to the graphical session below).
    services.network-manager-applet.enable = true;

    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
    xdg.configFile."hypr/wallpaper.png".source = ./wallpaper.png;
    xdg.configFile."hypr/green-mountains.jpg".source = ./green-mountains.jpg;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;

    systemd.user.targets.tray.Unit.Requires = lib.mkForce [ "graphical-session.target" ];

    home.sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
    };

  };

}
