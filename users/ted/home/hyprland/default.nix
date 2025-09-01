{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.veritas.configs.hyprland;
in
{
  imports = [ ];

  options.veritas.configs.hyprland = {
    enable = lib.mkEnableOption "hyprland configuration";
  };

  config = lib.mkIf cfg.enable {

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

      # settings = {
      #   "$mod" = "SUPER";
      #   "exec-once" = [ "waybar" ];
      #
      #   monitor = [ ", preffered, auto, auto" "eDP1, preffered, auto, 1.6" ];
      #
      #   general = {
      #     gaps_in = 5;
      #     gaps_out = 5;
      #     border_size = 1;
      #     allow_tearing = true;
      #     resize_on_border = true;
      #   };
      #
      #   decoration = {
      #     rounding = 4;
      #     rounding_power = 3;
      #   };
      #
      #   input = { kb_options = "caps:swapescape"; };
      #
      #   bind = [
      #     "$mod SHIFT, Q, killactive,"
      #     "$mod SHIFT, E, exec, pkill Hyprland"
      #
      #     "$mod, F22, exec, brave"
      #
      #     "$mod, O, exec, rofi -show drun"
      #     "$mod, B, exec, rofi -show run"
      #     "$mod, P, exec, kitty"
      #     "$mod, Return, exec, kitty"
      #     "$mod, G, togglegroup,"
      #
      #   ] ++ (builtins.concatLists (builtins.genList (i:
      #     let ws = i + 1;
      #     in [
      #       "$mod, code:1${toString i}, workspace, ${toString ws}"
      #       "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
      #     ]) 9));
      #
      # };
    };

    programs.waybar = {
      enable = true;
    };

    home.packages = [
      pkgs.hyprpaper
      pkgs.hypridle
      pkgs.hyprlock
    ];

    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
    xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf;
    xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
    xdg.configFile."hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    xdg.configFile."hypr/wallpaper.png".source = ./wallpaper.png;
    xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ./waybar/style.css;

    systemd.user.targets.tray.Unit.Requires = lib.mkForce [ "graphical-session.target" ];

    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

  };

}
