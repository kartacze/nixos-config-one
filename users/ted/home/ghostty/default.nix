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
  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      # nixpkgs ghostty is Linux-only; on Darwin the user installs
      # ghostty-bin at system level (see users/ted/darwin.nix) and
      # still reads this same HM-written config.
      package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
      settings = {
        theme = "Gruvbox Dark Hard";
        shell-integration = "fish";
      };
    };
  };
}
