{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.veritas.configs.gaming.enable {
    hardware.steam-hardware.enable = true;

    # Newest stable kernel for gaming hardware (graphics/input drivers).
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
