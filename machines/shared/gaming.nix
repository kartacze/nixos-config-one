{ config, lib, ... }:

{
  config = lib.mkIf config.veritas.configs.gaming.enable {
    hardware.steam-hardware.enable = true;
  };
}
