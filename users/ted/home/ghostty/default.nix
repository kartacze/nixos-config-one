{
  config,
  lib,
  ...
}:

let
  cfg = config.veritas.configs.ghostty;
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile."ghostty/config.ghostty".source = ./config.ghostty;
  };
}
