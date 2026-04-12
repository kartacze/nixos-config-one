{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.ghostty;

in
{
  options.veritas.configs.ghostty = {
    enable = lib.mkEnableOption "ghostty configuration";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."ghostty/config.ghostty".source = ./config.ghostty;
  };
}
