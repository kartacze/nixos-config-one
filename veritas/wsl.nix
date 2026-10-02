# Per-host veritas flags for wsl.
# Applied directly by lib/mksystem.nix (not via machines/*.nix).
# CLI tools on, GUI/gaming off.
{
  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    starship.enable = true;
    ghostty.enable = false;
    hyprland.enable = false;
    gaming.enable = false;
  };
}
