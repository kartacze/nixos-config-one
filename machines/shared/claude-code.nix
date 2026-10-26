{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.claudeCode.enable {
    # Official pre-built Claude Code binaries, updated hourly upstream.
    # `nix flake update nix-claude-code` picks up a new release.
    nixpkgs.overlays = [ inputs.nix-claude-code.overlays.default ];

    environment.systemPackages = [ pkgs.claude-code ];

    # Upstream's Cachix, so rebuilds fetch the wrapped binary instead of
    # building it locally.
    nix.settings = {
      substituters = [ "https://ryoppippi.cachix.org" ];
      trusted-public-keys = [
        "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
      ];
    };
  };
}
