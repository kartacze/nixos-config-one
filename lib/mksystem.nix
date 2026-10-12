# This function creates a NixOS system based on our VM setup for a
# particular architecture.
{ nixpkgs, inputs }:

name:
{
  system,
  user,
  darwin ? false,
}:

let
  # The config files for this system.
  machineConfig = ../machines/${name}.nix;
  userOSConfig = ../users/ted/${if darwin then "darwin" else "nixos"}.nix;
  userHMConfig = ../users/ted/home-manager.nix;

  nixvim = inputs.nixvim.homeModules.nixvim;
  veritasOptions = ../modules/veritas-options.nix;

  # Veritas flags are applied directly here, not via machines/*.nix.
  # Per-host source of truth: veritas/<name>.nix (e.g. veritas/x1-intel.nix).
  veritasHostPath = ../veritas + "/${name}.nix";
  veritasHost = if builtins.pathExists veritasHostPath then veritasHostPath else { };

  # Auto-logic fallback (used when veritas/<name>.nix is missing, e.g. a
  # new/VM host): CLI tools on, gaming off, GUI off on darwin.
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
        ghostty.enable = lib.mkDefault true;
        hyprland.enable = lib.mkDefault (!darwin);
        printing3D.enable = lib.mkDefault false;
      };
    };
  # NixOS vs nix-darwin functions
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  nixosHardwareModules =
    if name == "latitude-7390" then
      [ inputs.nixos-hardware.nixosModules.dell-latitude-7390 ]
    else if name == "g5555-intel" then
      # Dell G15 (Intel CPU + NVIDIA PRIME, no dedicated profile upstream):
      # generic Intel/NVIDIA/laptop modules. Manual PRIME offload config
      # lives in machines/hardware/g5555-intel.nix.
      with inputs.nixos-hardware.nixosModules;
      [
        common-cpu-intel
        common-gpu-intel
        common-gpu-nvidia
        common-pc-laptop
        common-pc-laptop-ssd
      ]
    else if name == "x1-intel" then
      with inputs.nixos-hardware.nixosModules;
      [
        lenovo-thinkpad-x1-9th-gen
        common-cpu-intel
        common-gpu-intel
        common-pc-laptop-ssd
      ]
    else
      [ ];

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
  };

in
systemFunc rec {
  inherit system;

  modules = [
    # Declare veritas.configs.* flags before anything reads/sets them.
    veritasOptions
    # Auto defaults (darwin-aware), then per-host veritas/<name>.nix.
    veritasDefaults
    veritasHost
    machineConfig
  ]
  ++ nixosHardwareModules
  ++ [
    userOSConfig
    home-manager.home-manager

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.users.${user} = import userHMConfig { };

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
