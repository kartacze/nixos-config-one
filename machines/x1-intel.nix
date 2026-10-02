{ ... }:
{
  imports = [
    ./hardware/x1-intel.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Veritas flags live in veritas/x1-intel.nix (applied by lib/mksystem.nix).

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

}
