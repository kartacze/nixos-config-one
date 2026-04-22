{ pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./git.nix
    ./fish/default.nix
    ./nixvim/default.nix
    ./tmux/default.nix
    ./hyprland/default.nix
    ./starship/default.nix
    ./ghostty/default.nix
  ];

  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    hyprland.enable = isLinux;
    ghostty.enable = true;
    starship.enable = true;
  };
}
