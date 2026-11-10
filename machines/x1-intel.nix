{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware/x1-intel.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Livebook runs as a local user service on x1 (machines/shared/livebook.nix
  # enables it for desktop hosts). LIVEBOOK_PASSWORD and LIVEBOOK_COOKIE come
  # from sops instead of that module's default /var/lib/livebook.env. The unit
  # is read by ted's user manager, so the secret has to be owned by ted.
  sops.secrets."livebook-env" = {
    owner = "ted";
    mode = "0400";
  };
  services.livebook.environmentFile = lib.mkForce config.sops.secrets."livebook-env".path;
  services.livebook.environment.LIVEBOOK_NODE = "livebook@127.0.0.1";

  # Read-only view of the phone photo backup on zamoyski, mounted on demand.
  # The login key is passphrase-protected, so the root-owned system mount uses
  # the passphrase-less `server_ed25519` key instead (authorized on zamoyski).
  # The server shares the folder only over the tailnet.
  # pre-commit: keeps the store path used by .git/hooks alive across GC, as
  # git-hooks follows this flake's nixpkgs and so resolves to the same package.
  environment.systemPackages = [
    pkgs.sshfs
    pkgs.pre-commit
  ];

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

  # Read-only view of the `zamoyski-phone` folder (synced both ways between
  # the phone and zamoyski), mounted the same way as the photos.
  fileSystems."/mnt/zamoyski-phone" = {
    device = "mtp-zamoyski@100.64.0.1:/var/lib/zamoyski-phone";
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
