{ pkgs, ... }:

{
  # homebrew = { enable = true; casks = [ ]; };
  # environment.pathsToLink = [ "/share/fish" ];
  # environment.shells = with pkgs; [ fish ];

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/nix-darwin/nix-darwin/issues/423).
  users.users."teodorp" = {
    home = "/Users/teodorp";
    shell = pkgs.fish;

    packages = [
      pkgs.ghostty-bin
      pkgs.bun
    ];
  };

  system.stateVersion = 5;
}
