# Intel-only laptop power profile (x1-intel, latitude-7390).
#
# Do NOT import this on NVIDIA hosts (g5555-intel): the nouveau/nvidia
# module blacklist and the NVIDIA PCI-removal udev rules below would
# break PRIME offload there.
{
  ...
}:

{

  # Single power-management stack: power-profiles-daemon (dynamic
  # governors / EPP) + thermald (Intel thermal). These two cooperate
  # (thermal vs power policy); do NOT add TLP/auto-cpufreq alongside
  # power-profiles-daemon — they fight over governors.
  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = true;

    udev.extraRules = ''
      # Remove NVIDIA USB xHCI Host Controller devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA USB Type-C UCSI devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA Audio devices, if present
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
      # Remove NVIDIA VGA/3D controller devices
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
    '';
  };
  boot = {
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
    ];
  };
}
