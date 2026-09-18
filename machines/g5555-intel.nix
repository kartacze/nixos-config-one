{
  pkgs,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./hardware/g5555-intel.nix
    ./shared.nix
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

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # This works through our custom module imported above

}
