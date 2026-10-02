{ pkgs, ... }:

{
  imports = [
    ./nixos/gaming.nix
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

  users.users.ted = {
    isNormalUser = true;
    home = "/home/ted";
    extraGroups = [
      "docker"
      "wheel"
    ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$D7FDR5mTReMHtGsU4t0sG1$i9C6ltgqCy7VD7/zwA2t0r/GjYzNd4omdGZOaWjHFR9";
  };
}
