{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # gicz-server.url = "path:///home/ted/workspace/winpol/gicz";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nixvim,
      nixos-hardware,
      ...
    }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
    in
    {

      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        user = "ted";
      };

      nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" rec {
        system = "aarch64-linux";
        user = "ted";
      };

      nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
        system = "aarch64-linux";
        user = "ted";
      };

      nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
        system = "x86_64-linux";
        user = "ted";
      };

      nixosConfigurations.g5555-intel = mkSystem "g5555-intel" rec {
        system = "x86_64-linux";
        user = "ted";
      };

      nixosConfigurations.latitude-7390 = mkSystem "latitude-7390" rec {
        system = "x86_64-linux";
        user = "ted";
        isLatitude = true;
      };

      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "ted";
        wsl = true;
      };

      darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
        system = "aarch64-darwin";
        user = "teodorp";
        darwin = true;
      };

    };
}
