{ config, lib, ... }:

let
  cfg = config.veritas.configs.syncthing;

  # Bind to the host's tailscale address when it is declared, so the web UI
  # and the sync listener are not reachable on LAN/WAN at all. Hosts without
  # a declared address fall back to all interfaces; the firewall
  # (machines/shared/syncthing.nix) still confines them to tailscale0.
  listenAddress = if cfg.tailscaleIP == null then "0.0.0.0" else cfg.tailscaleIP;
in
{
  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;

      # Web UI on the tailnet: open http://${listenAddress}:8384 on any
      # tailscale device to pair peers and add folders. Pairing is
      # interactive, so devices and folders are deliberately undeclared; the
      # overrides below keep entries added in the web UI from being wiped on
      # activation.
      guiAddress = "${listenAddress}:8384";
      overrideDevices = false;
      overrideFolders = false;

      settings.options = {
        # Never listen on LAN/loopback/wildcard: only the tailscale address.
        listenAddresses = [
          "tcp://${listenAddress}:22000"
          "quic://${listenAddress}:22000"
        ];
        # Keep sync inside the tailnet: no LAN broadcast, no NAT traversal,
        # no public relays. Global discovery only announces the tailscale
        # address, which is unroutable from outside the tailnet.
        localAnnounceEnabled = false;
        relaysEnabled = false;
        natEnabled = false;
      };
    };
  };
}
