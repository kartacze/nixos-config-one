{
  config,
  lib,
  pkgs,
  ...
}:

let
  # True once the age-encrypted secrets/ted.yaml exists (see comment
  # below). Guarded so `nix flake check` passes before the first secret
  # is created; string concat (not a path literal) keeps missing files
  # from failing evaluation.
  hasSopsSecrets = builtins.pathExists (../.. + "/secrets/ted.yaml");
in
{
  imports = [
    ./nixos/gaming.nix
    ./nixos/printing3D.nix
  ];

  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  services.mullvad-vpn = {
    enable = false;
  };

  # services.gicz-server = {
  #   enable = true;
  #   host = "localhost";
  #   secretKeyBaseFile = ./secretKey;
  #   databaseUrlFile = ./databaseUrl;
  # };

  programs.fish.enable = true;

  # Single definition of the ted user (was duplicated in
  # machines/shared.nix; groups merged from there).
  #
  # Password comes from sops-nix, never from git. Create the secret once
  # per host (sops-nix decrypts with the host's ssh_host_ed25519_key):
  #   1. ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub  # -> age1... key
  #   2. put it in secrets/.sops.yaml under that host's creation rule
  #   3. sops secrets/ted.yaml  # add: ted/hashedPassword: <mkpasswd -m yescrypt output>
  # Until secrets/ted.yaml exists the account has no password (key-only
  # SSH); set one post-install with `passwd ted`.
  sops.defaultSopsFile = lib.mkIf hasSopsSecrets (../.. + "/secrets/ted.yaml");
  sops.secrets."ted/hashedPassword" = lib.mkIf hasSopsSecrets {
    neededForUsers = true;
  };

  users.users.ted = {
    isNormalUser = true;
    description = "ted";
    home = "/home/ted";
    extraGroups = [
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
    hashedPasswordFile = lib.mkIf hasSopsSecrets config.sops.secrets."ted/hashedPassword".path;
  };

}
