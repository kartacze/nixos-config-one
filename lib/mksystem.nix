# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{
  system,
  user,
  darwin ? false,
  wsl ? false,
}:

let
  # True if this is a WSL system.
  isWSL = wsl;

  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/ted/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/ted/home-manager.nix;

  nixvim = inputs.nixvim.homeModules.nixvim;
  veritasOptions = ../modules/veritas-options.nix;

  # Veritas flags are applied directly here, not via machines/*.nix.
  # Per-host source of truth: veritas/<name>.nix (e.g. veritas/wsl.nix).
  veritasHostPath = ../veritas + "/${name}.nix";
  veritasHost = if builtins.pathExists veritasHostPath then veritasHostPath else { };

  # Auto-logic fallback (used when veritas/<name>.nix is missing, e.g. a
  # new/VM host): CLI tools on, gaming off, GUI off on WSL/darwin.
  # veritas/<name>.nix wins over these mkDefault values when it exists.
  veritasDefaults =
    { lib, ... }:
    {
      veritas.configs = {
        git.enable = lib.mkDefault true;
        nixvim.enable = lib.mkDefault true;
        fish.enable = lib.mkDefault true;
        tmux.enable = lib.mkDefault true;
        starship.enable = lib.mkDefault true;
        gaming.enable = lib.mkDefault false;
        ghostty.enable = lib.mkDefault (!isWSL);
        hyprland.enable = lib.mkDefault (!isWSL && !darwin);
      };
    };
  # NixOS vs nix-darwin functionst
  systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  nixos-hardware =
    if name == "latitude-7390" then
      inputs.nixos-hardware.nixosModules.dell-latitude-7390
    else if name == "x1-intel" then
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    else
      { };

  home-manager =
    if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

  # Values set once at system level (veritas/<name>.nix via mksystem).
  # They are mirrored into home-manager below so that users/ted/home/*
  # modules see the same `config.veritas.configs.*` values.
  # They are also exposed to every module (system + home) via
  # extraSpecialArgs / _module.args.
  hostArgs = {
    inherit inputs;
    currentSystem = system;
    currentSystemName = name;
    currentSystemUser = user;
    isWSL = isWSL;
  };

in
systemFunc rec {
  inherit system;

  modules = [
    # Declare veritas.configs.* flags before anything reads/sets them.
    veritasOptions
    # Auto defaults (WSL/darwin-aware), then per-host veritas/<name>.nix.
    veritasDefaults
    veritasHost
    # Bring in WSL if this is a WSL build
    (if isWSL then inputs.nixos-wsl.nixosModules.wsl else { })
    machineConfig
    nixos-hardware
    userOSConfig
    home-manager.home-manager

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.users.${user} = import userHMConfig {
        isWSL = isWSL;
        inputs = inputs;
      };

      home-manager.extraSpecialArgs = hostArgs;
      home-manager.sharedModules = [
        nixvim
        veritasOptions
        veritasDefaults
        veritasHost
      ];
    }

    # We expose some extra arguments so that our modules can parameterize
    # better based on these values. Keep in sync with extraSpecialArgs
    # above (same hostArgs) so system modules and home modules see the
    # same values.
    {
      config._module.args = hostArgs;
    }
  ];
}
