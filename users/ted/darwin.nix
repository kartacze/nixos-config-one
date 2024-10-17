{ inputs, pkgs, ... }:

{
  imports = [ ./nixvim.nix ];

  # homebrew = { enable = true; casks = [ ]; };
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH

  # Since we're using fish as our shell
  programs.fish.enable = true;
  programs.tmux.enable = true;

  # veritas.configs = { nixvim.enable = false; };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.teodorp = {
    home = "/Users/teodorp";
    shell = pkgs.fish;
  };
}
