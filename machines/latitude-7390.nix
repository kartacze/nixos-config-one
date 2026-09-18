{
  ...
}:
{
  imports = [
    ./hardware/latitude-7390.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = true;
    tmux.enable = true;
    hyprland.enable = true;
    ghostty.enable = true;
    starship.enable = true;
  };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
}
