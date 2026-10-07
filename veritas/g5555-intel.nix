# Per-host veritas flags for g5555-intel.
# Applied directly by lib/mksystem.nix (not via machines/*.nix).
{
  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    hyprland.enable = true;
    ghostty.enable = true;
    starship.enable = true;
    gaming.enable = true;
    printing3D.enable = true;
  };
}
