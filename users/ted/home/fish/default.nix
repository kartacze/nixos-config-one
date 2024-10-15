{ config, lib, pkgs, ... }:

let cfg = config.veritas.configs.fish;

in {
  options.veritas.configs.fish = {
    enable = lib.mkEnableOption "fish configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ zoxide ];

    programs.fish = {
      enable = true;
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };

  };
}
