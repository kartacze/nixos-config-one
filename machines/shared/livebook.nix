{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.desktopApps.enable {
    # Pythonx downloads generic Linux binaries for uv and Python.
    programs.nix-ld.enable = true;

    services.livebook = {
      environment = {
        NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
        NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
        # Erlang distribution otherwise listens on all interfaces, and anyone
        # holding the cookie could run code.
        ERL_AFLAGS = "-kernel inet_dist_use_interface {127,0,0,1}";
      };
      enableUserService = true;
      package = pkgs.livebook;
      extraPackages = with pkgs; [
        gcc
        gnumake
      ];
      environmentFile = "/var/lib/livebook.env";
    };

    # http://livebook.localhost → Livebook. *.localhost resolves to loopback in
    # browsers and via nss-myhostname, so no DNS/hosts entry is needed. Caddy
    # binds loopback only; Livebook itself stays on 127.0.0.1:8080.
    services.caddy = {
      enable = true;
      virtualHosts."http://livebook.localhost".extraConfig = ''
        bind 127.0.0.1 ::1
        reverse_proxy 127.0.0.1:8080
      '';
    };
  };
}
