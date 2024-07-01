{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = import ../../lib/overlays.nix;


  homebrew = { enable = true; casks = [ ]; };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.teodorp = {
    home = "/Users/teodorp";
    shell = pkgs.fish;
  };
}
