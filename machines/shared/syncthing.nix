{ config, lib, ... }:

{
  config = lib.mkIf config.veritas.configs.syncthing.enable {
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
