{ ... }:
{
  imports = [
    ./hardware/x1-intel.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Install-time release for stateful-data defaults. Never bump on a
  # working system (see NixOS manual, `system.stateVersion`).
  system.stateVersion = "24.05";

}
