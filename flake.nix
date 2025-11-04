{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = { url = "github:nix-community/nixvim"; };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, ... }@inputs:
    let mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
    in {

      # nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
      #   system = "aarch64-linux";
      #   user = "ted";
      # };
      #
      # nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" rec {
      #   system = "aarch64-linux";
      #   user = "ted";
      # };
      #
      # nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
      #   system = "aarch64-linux";
      #   user = "ted";
      # };
      #
      # nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
      #   system = "x86_64-linux";
      #   user = "ted";
      # };
      #
      # nixosConfigurations.g5555-intel = mkSystem "g5555-intel" rec {
      #   system = "x86_64-linux";
      #   user = "ted";
      # };
      #
      # nixosConfigurations.latitude-7390 = mkSystem "latitude-7390" rec {
      #   system = "x86_64-linux";
      #   user = "ted";
      #   isLatitude = true;
      # };
      #
      # nixosConfigurations.x1-intel = mkSystem "x1-intel" rec {
      #   system = "x86_64-linux";
      #   user = "ted";
      #   isLatitude = false;
      # };
      #
      # nixosConfigurations.wsl = mkSystem "wsl" {
      #   system = "x86_64-linux";
      #   user = "ted";
      #   wsl = true;
      # };

      darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
        system = "aarch64-darwin";
        user = "teodor.pytka";
        darwin = true;
      };

    };
}
