{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # programs.steam.enable = true;
  # services.gicz-server = {
  #   enable = true;
  #   host = "localhost";
  #   secretKeyBaseFile = ./secretKey;
  #   databaseUrlFile = ./databaseUrl;
  # };

  users.users.ted = {
    isNormalUser = true;
    home = "/home/ted";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword =
      "$y$j9T$D7FDR5mTReMHtGsU4t0sG1$i9C6ltgqCy7VD7/zwA2t0r/GjYzNd4omdGZOaWjHFR9";
  };
}
