# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{ system, user, darwin ? false, wsl ? false, isLatitude ? false }:

let
  # True if this is a WSL system.
  isWSL = wsl;

  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/ted/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/ted/home-manager.nix;

  nixvim = inputs.nixvim.homeManagerModules.nixvim;
  # NixOS vs nix-darwin functionst
  systemFunc =
    if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  nixos-hardware = if isLatitude then
    inputs.nixos-hardware.nixosModules.dell-latitude-7390
  else
    { };

  home-manager = if darwin then
    inputs.home-manager.darwinModules
  else
    inputs.home-manager.nixosModules;

in systemFunc rec {
  inherit system;

  modules = [
    # Bring in WSL if this is a WSL build
    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else { })
    machineConfig
    nixos-hardware
    userOSConfig
    home-manager.home-manager

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        isWSL = isWSL;
        inputs = inputs;
      };

      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.sharedModules = [ nixvim ];
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values.
    {
      config._module.args = {
        currentSystem = system;
        currentSystemName = name;
        currentSystemUser = user;
        isWSL = isWSL;
        inputs = inputs;
      };
    }
  ];
}
