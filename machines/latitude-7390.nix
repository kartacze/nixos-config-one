{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/latitude-7390.nix ./shared.nix ];

  # hardware.cpu.intel.updateMicrocode = true;

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     vaapiIntel
  #     vaapiVdpau
  #     libvdpau-va-gl
  #     intel-media-driver
  #   ];
  # };

  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;

}
