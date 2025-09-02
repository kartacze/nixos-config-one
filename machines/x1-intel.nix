{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/x1-intel.nix ./shared.nix ./hardware/battery.nix ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

}
