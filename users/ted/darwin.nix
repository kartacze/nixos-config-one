{ inputs, pkgs, ... }:

{
  # homebrew = { enable = true; casks = [ ]; };
  # environment.pathsToLink = [ "/share/fish" ];
  # environment.shells = with pkgs; [ fish ];

  programs.tmux.enable = true;

  environment.systemPackages = [
    # pkgs.fish
  ];

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users."teodor.pytka" = {
    home = "/Users/teodor.pytka";
    shell = pkgs.fish;

    packages = [
      pkgs.ghostty-bin
      pkgs.bun
    ];
  };

  system.stateVersion = 5;
}
