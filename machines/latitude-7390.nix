{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/latitude-7390.nix ./shared.nix ];

   boot.kernel.sysctl."kernel.sysrq" = 1;
   boot.kernelPackages = pkgs.linuxPackages_4_19;

   hardware.cpu.intel.updateMicrocode = true;

   hardware.firmware = with pkgs; [
     firmwareLinuxNonfree
   ];
  
   hardware.opengl = {
     enable = true;
     extraPackages = with pkgs; [
       vaapiIntel
       vaapiVdpau
       libvdpau-va-gl
       intel-media-driver
     ];
   };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;

  # This works through our custom module imported above
  virtualisation.vmware.guest.enable = true;

}
