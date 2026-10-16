{ ... }:

{
  imports = [
    ./hardware/g5555-intel.nix
    ./shared.nix
  ];

  # Install-time release for stateful-data defaults. Never bump on a
  # working system (see NixOS manual, `system.stateVersion`).
  system.stateVersion = "24.05";
}
