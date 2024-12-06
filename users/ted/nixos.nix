{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  # programs.steam.enable = true;

  nixpkgs.config.permittedInsecurePackages = {
    nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];
  };

  users.users.ted = {
    isNormalUser = true;
    home = "/home/ted";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    hashedPassword =
      "$y$j9T$D7FDR5mTReMHtGsU4t0sG1$i9C6ltgqCy7VD7/zwA2t0r/GjYzNd4omdGZOaWjHFR9";
  };
}
