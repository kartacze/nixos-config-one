{
  ...
}:
{
  imports = [
    ./hardware/latitude-7390.nix
    ./shared.nix
    ./hardware/battery.nix
  ];

  # Install-time release for stateful-data defaults. Never bump on a
  # working system (see NixOS manual, `system.stateVersion`).
  system.stateVersion = "24.05";
}
