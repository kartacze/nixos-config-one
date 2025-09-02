{ config, pkgs, lib, ... }: {
  imports =
    [ ./hardware/latitude-7390.nix ./shared.nix ./hardware/battery.nix ];

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
}
