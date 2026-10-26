{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.passage;
in
{
  config = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
    # Keep the store at its default location, but make the identity
    # explicit: the sops-provisioned age key, not ~/.passage/identities
    # (which may still point at the old SSH key).
    home.sessionVariables = {
      PASSAGE_DIR = "${config.home.homeDirectory}/.passage/store";
      PASSAGE_IDENTITIES_FILE = "/run/secrets/passage-age-key";
    };
  };
}
