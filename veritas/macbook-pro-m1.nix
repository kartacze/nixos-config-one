# Per-host veritas flags for macbook-pro-m1 (darwin).
# Applied directly by lib/mksystem.nix (not via machines/*.nix).
{
  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    hyprland.enable = false;
    ghostty.enable = true;
    starship.enable = true;
    gaming.enable = false;
  };
}
