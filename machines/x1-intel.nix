{
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./hardware/x1-intel.nix
    ./shared.nix
    ./hardware/battery.nix
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

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

}
