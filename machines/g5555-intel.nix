{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/g5555-intel.nix ./shared.nix ];

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  # This works through our custom module imported above

}
