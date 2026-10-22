{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./fish/default.nix
    ./nixvim/default.nix
    ./tmux/default.nix
    ./hyprland/default.nix
    ./syncthing/default.nix
    ./ghostty/default.nix
    ./kitty/default.nix
  ];
}
