{ pkgs, ... }:

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
}
