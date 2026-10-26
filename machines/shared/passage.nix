{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.passage.enable {
    # passage is a pass fork backed by age. The store itself lives in
    # ~/.passage/store and is cloned from the tailnet-only Forgejo repo
    # (ted/agepass); Nix only provides the package and the decryption
    # identity.
    environment.systemPackages = [ pkgs.passage ];

    # Dedicated age identity for the password store. It is separate from
    # the SSH auth key and from the sops admin key, so rotating SSH keys
    # does not lock you out of passage. The matching public recipient is
    # in ~/.passage/store/.age-recipients (committed to the store repo).
    #
    # Only hosts with `veritas.configs.passage.enable` get this secret,
    # and those hosts must be sops recipients in secrets/.sops.yaml.
    sops.secrets."passage-age-key" = {
      owner = "ted";
      mode = "0400";
    };
  };
}
