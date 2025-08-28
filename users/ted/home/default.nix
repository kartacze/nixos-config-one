{ inputs, ... }:

{
  imports = [
    ./git.nix
    ./fish/default.nix
    ./nixvim/default.nix
    ./tmux/default.nix
    ./hyprland/default.nix
  ];

  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = false;
    tmux.enable = true;
    hyprland.enable = true;
  };
}
