{
  config,
  lib,
  currentSystemName,
  ...
}:

let
  cfg = config.veritas.configs.syncthing;

  # Public halves of the peers' pinned identities. The matching cert/key pairs
  # live in secrets/ted.yaml and are installed by machines/shared/syncthing.nix.
  # Device IDs are public keys, so they are safe to keep in the repo.
  peers = {
    mtp-zamoyski = {
      id = "NA5R5KO-D4Y4QPV-5C7FRTG-LPJFHYW-NPI33OV-F7EATCQ-K2RQNXV-J6W3JQE";
      addresses = [
        "tcp://100.64.0.1:22000"
        "quic://100.64.0.1:22000"
      ];
    };
  };

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

      # Identity is pinned on hosts with `veritas.configs.syncthing.pinned`:
      # the cert/key pair is copied out of sops before the service starts, so
      # the device ID is reproducible and survives rebuilds.
      #
      # Web UI on the tailnet: open http://${listenAddress}:8384 on any
      # tailscale device. On pinned hosts devices and folders are declared
      # below, so anything added through the UI is removed on the next
      # activation; other hosts keep pairing interactively.
      cert = lib.mkIf cfg.pinned "/run/secrets/syncthing-${currentSystemName}-cert";
      key = lib.mkIf cfg.pinned "/run/secrets/syncthing-${currentSystemName}-key";
      guiAddress = "${listenAddress}:8384";
      overrideDevices = cfg.pinned;
      overrideFolders = cfg.pinned;

      settings = {
        options = {
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
      }
      // lib.optionalAttrs cfg.pinned {
        devices = lib.filterAttrs (name: _: name != currentSystemName) peers;

        # One-way backup of ~/Documents to the home server. The server side is
        # `receiveonly`, so it never pushes changes back. The folder id must
        # match the one declared on the server.
        folders."${config.home.homeDirectory}/Documents" = {
          id = "newhw-nghmf";
          label = "Documents";
          type = "sendonly";
          devices = [ "mtp-zamoyski" ];
        };
      };
    };
  };
}
