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
    };

    programs.waybar = {
      enable = true;
    };

    home.packages = [
      pkgs.hyprpaper
      pkgs.hypridle
      pkgs.hyprlock
      pkgs.hyprutils
      pkgs.hyprlauncher
    ];

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

    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
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
