{
  config,
  lib,
  currentSystemName,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.syncthing.enable {
    # Pinned Syncthing identity. These are referenced by
    # users/ted/home/syncthing/default.nix as /run/secrets/syncthing-$HOST-*.
    # They are owned by the login user because the home-manager module runs
    # Syncthing as a user service and copies the files from there.
    #
    # Only hosts with `veritas.configs.syncthing.pinned` have an entry in
    # secrets/ted.yaml; the others keep pairing through the web UI.
    sops.secrets = lib.mkIf config.veritas.configs.syncthing.pinned {
      "syncthing-${currentSystemName}-cert" = {
        owner = "ted";
        mode = "0400";
      };
      "syncthing-${currentSystemName}-key" = {
        owner = "ted";
        mode = "0400";
      };
    };

    # Syncthing is a tailnet-only service: the web UI (8384) and the sync
    # listener (22000 tcp/udp) are opened on the tailscale interface only,
    # never on LAN/WAN interfaces. See
    # users/ted/home/syncthing/default.nix for the bind addresses.
    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [
        8384
        22000
      ];
      allowedUDPPorts = [ 22000 ];
    };
  };
}
