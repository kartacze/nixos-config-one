# Per-host veritas flags for g5555-intel.
# Applied directly by lib/mksystem.nix (not via machines/*.nix).
{
  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    hyprland.enable = true;
    syncthing = {
      enable = true;
      tailscaleIP = "100.64.0.5";
    };
    ghostty.enable = true;
    gaming.enable = true;
    printing3D.enable = true;
  };
}
