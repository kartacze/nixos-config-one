{
  lib,
  pkgs,
  ...
}:

let
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

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = [ "--login-server=https://headscale.zivix.pl" ];
  };

  programs.fish.enable = true;

  sops.defaultSopsFile = lib.mkIf hasSopsSecrets (../.. + "/secrets/ted.yaml");

  users.users.ted = {
    isNormalUser = true;
    description = "ted";
    home = "/home/ted";
    # The login password is intentionally not managed by sops; set it
    # manually with `passwd ted` on a fresh install.
    extraGroups = [
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.fish;
  };

}
