{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.desktopApps.enable {
    services.livebook = {
      enableUserService = true;
      package = pkgs.livebook;
      extraPackages = with pkgs; [
        gcc
        gnumake
      ];
      environmentFile = "/var/lib/livebook.env";
    };
  };
}
