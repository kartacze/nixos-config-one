{
  ...
}:
{
  imports = [
    ./hardware/latitude-7390.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Veritas flags live in veritas/latitude-7390.nix (applied by lib/mksystem.nix).

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
}
