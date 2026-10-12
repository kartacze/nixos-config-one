{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
    in

    {
      nixosConfigurations.g5555-intel = mkSystem "g5555-intel" rec {
        system = "x86_64-linux";
        user = "ted";
      };

      nixosConfigurations.latitude-7390 = mkSystem "latitude-7390" rec {
        system = "x86_64-linux";
        user = "ted";
      };

      nixosConfigurations.x1-intel = mkSystem "x1-intel" rec {
        system = "x86_64-linux";
        user = "ted";
      };

      darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
        system = "aarch64-darwin";
        user = "teodorp";
        darwin = true;
      };
    };
}
