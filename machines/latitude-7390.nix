{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/latitude-7390.nix ./shared.nix ];

  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     vaapiIntel
  #     vaapiVdpau
  #     libvdpau-va-gl
  #     intel-media-driver
  #   ];
  # };

  # hardware.cpu.intel.updateMicrocode = true;
  # boot.kernel.sysctl."kernel.sysrq" = 502;
  hardware.enableAllFirmware = true;

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;
}
