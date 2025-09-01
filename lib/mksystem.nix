# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{ system, user, darwin ? false, wsl ? false, isLatitude ? false, }:

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

  nixos-hardware = if name == "latitude-7390" then
    inputs.nixos-hardware.nixosModules.dell-latitude-7390
  else if name == "x1-intel" then
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
  else
    { };

  # gicz-server = inputs.gicz-server.outputs.packages.x86_64-linux.nixosModule;

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
    # gicz-server

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
