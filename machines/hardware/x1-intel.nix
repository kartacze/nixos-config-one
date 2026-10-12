# ThinkPad X1 Carbon Gen 9 - Intel TigerLake-LP GT2 [Iris Xe Graphics].
# Intel-only machine: no NVIDIA dGPU. Keep this file Intel-specific;
# NVIDIA PRIME bits live in machines/hardware/g5555-intel.nix only.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/49598a18-89a8-4de4-9fe2-a16c28be08f2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E307-A1D8";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/0e9c46aa-435d-4e38-a3aa-1ef5c6ebfce0"; } ];

  services.udisks2.enable = true;
  services.fwupd.enable = true;
  services.fstrim.enable = lib.mkDefault true;
  powerManagement.enable = true;

  # ThinkPad battery longevity: start charging below 80%, stop at 90%.
  # EC-persisted via thinkpad_acpi (BAT0/BAT1). Handles both legacy
  # (charge_start/stop_threshold) and modern (charge_control_*) sysfs names.
  # Kept here (not battery.nix) so latitude-7390 is unaffected.
  systemd.services.thinkpad-battery-thresholds = {
    description = "Set ThinkPad battery charge thresholds (80/90)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for bat in /sys/class/power_supply/BAT0 /sys/class/power_supply/BAT1; do
        [ -d "$bat" ] || continue
        if [ -w "$bat/charge_control_start_threshold" ]; then
          echo 80 > "$bat/charge_control_start_threshold"
        elif [ -w "$bat/charge_start_threshold" ]; then
          echo 80 > "$bat/charge_start_threshold"
        fi
        if [ -w "$bat/charge_control_end_threshold" ]; then
          echo 90 > "$bat/charge_control_end_threshold"
        elif [ -w "$bat/charge_stop_threshold" ]; then
          echo 90 > "$bat/charge_stop_threshold"
        fi
      done
    '';
  };

  # Early KMS + virtualization.
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  # TigerLake: enable GuC/HuC firmware (media / HuC auth offload).
  boot.kernelParams = [ "i915.enable_guc=2" ];

  # Intel-only: use modesetting, NOT nvidia.
  services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    # 32-bit compat required by Steam.
    enable32Bit = lib.mkIf config.veritas.configs.gaming.enable true;
    # common-gpu-intel (imported via lib/mksystem.nix) provides
    # intel-media-driver + intel-vaapi-driver + OpenCL + OneVPL.
    # Only the VDPAU wrapper is missing upstream.
    extraPackages = with pkgs; [ libvdpau-va-gl ];
  };

  # VA-API on TigerLake wants the iHD driver.
  environment.sessionVariables.LIBVA_DRIVER_NAME = lib.mkDefault "iHD";

  # Single iGPU: it enumerates as /dev/dri/card1 on this machine
  # (pci-0000:00:02.0-card -> card1; there is no card0).
  environment.sessionVariables.WLR_DRM_DEVICES = lib.mkDefault "/dev/dri/card1";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp60s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
