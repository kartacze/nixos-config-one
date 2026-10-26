{ pkgs, ... }:
{
  imports = [
    ./hardware/x1-intel.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Read-only view of the phone photo backup on zamoyski, mounted on demand.
  # The login key is passphrase-protected, so the root-owned system mount uses
  # the passphrase-less `server_ed25519` key instead (authorized on zamoyski).
  # The server shares the folder only over the tailnet.
  environment.systemPackages = [ pkgs.sshfs ];

  # The mount is created by root, so other users (ted) need `allow_other`;
  # `default_permissions` keeps the remote mode bits enforced.
  programs.fuse.userAllowOther = true;

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
      "IdentityFile=/home/ted/.ssh/server_ed25519"
      "UserKnownHostsFile=/home/ted/.ssh/known_hosts"
    ];
  };

  # Install-time release for stateful-data defaults. Never bump on a
  # working system (see NixOS manual, `system.stateVersion`).
  system.stateVersion = "24.05";

}
