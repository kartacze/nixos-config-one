# Shared feature flags.
#
# Declare-only module: it defines the `veritas.configs.*.enable` options
# without implementing anything. It is imported very early (see
# lib/mksystem.nix) into BOTH evaluations that need the flags:
#
#   - the NixOS / nix-darwin system evaluation (machines/*, users/ted/nixos.nix)
#   - the home-manager evaluation (users/ted/home/*)
#
# Those are two separate module systems: an option declared only inside a
# home-manager module does NOT exist in the system evaluation (and vice
# versa), no matter the import order. Declaring everything here first is
# what allows setting/reading the flags from anywhere.
#
# The actual behavior behind each flag lives in the corresponding module
# (e.g. users/ted/home/fish/default.nix) as `config = lib.mkIf cfg.enable`.
{ lib, ... }:

{
  options.veritas.configs = {
    fish = {
      enable = lib.mkEnableOption "fish configuration";
    };
    gaming = {
      enable = lib.mkEnableOption "gaming configuration";
    };
    ghostty = {
      enable = lib.mkEnableOption "ghostty configuration";
    };
    git = {
      enable = lib.mkEnableOption "git configuration";
    };
    hyprland = {
      enable = lib.mkEnableOption "hyprland configuration";
    };
    nixvim = {
      enable = lib.mkEnableOption "nixvim configuration";
    };
    starship = {
      enable = lib.mkEnableOption "starship configuration";
    };
    tmux = {
      enable = lib.mkEnableOption "tmux configuration";
    };
  };
}
