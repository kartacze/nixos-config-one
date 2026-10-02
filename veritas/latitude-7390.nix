# Per-host veritas flags for latitude-7390.
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
    gaming.enable = false;
  };
}
