{ pkgs, ... }:

{
  imports = [
    ./hardware/g5555-intel.nix
    ./shared.nix
  ];

  # Read-only view of the phone photo backup on zamoyski, mounted on demand.
  # Same layout as x1-intel.nix. The passphrase-less mount key is delivered by
  # sops (it is authorized on zamoyski); the server shares the folder only over
  # the tailnet.
  sops.secrets."server_ed25519" = {
    owner = "root";
    mode = "0400";
    path = "/run/secrets/server_ed25519";
  };

  environment.systemPackages = [ pkgs.sshfs ];

  # The mount is created by root, so other users (ted) need `allow_other`;
  # `default_permissions` keeps the remote mode bits enforced.
  programs.fuse.userAllowOther = true;

  # Pin zamoyski's host key system-wide so the root-owned automount does not
  # depend on ted's ~/.ssh/known_hosts.
  programs.ssh.knownHosts."mtp-zamoyski" = {
    hostNames = [
      "100.64.0.1"
      "mtp-zamoyski"
    ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgWiQoilm65kAJ1t7rdsaKfA+Lv5Ung5O230bGd1hq8";
  };

  fileSystems."/mnt/zamoyski-photos" = {
    device = "mtp-zamoyski@100.64.0.1:/var/lib/photos-ted";
    fsType = "fuse.sshfs";
    options = [
      "ro"
      "allow_other"
      "default_permissions"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=15min"
      "reconnect"
      "ServerAliveInterval=15"
      "cache=yes"
      "kernel_cache"
      "compression=no"
      "uid=1000"
      "gid=100"
      "IdentityFile=/run/secrets/server_ed25519"
      "UserKnownHostsFile=/etc/ssh/ssh_known_hosts"
      "StrictHostKeyChecking=yes"
    ];
  };

  # Install-time release for stateful-data defaults. Never bump on a
  # working system (see NixOS manual, `system.stateVersion`).
  system.stateVersion = "24.05";
}
