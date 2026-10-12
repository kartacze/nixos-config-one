# Local-only CI hooks.
#
# Installed into .git/hooks on `nix develop`, enforced by `make lint`.
# No remote CI is configured for this repo by design.
#
# Deliberately no statix: its default ruleset conflicts with NixOS module
# idioms (`{ ... }:` args, repeated `services.*` keys). Run it manually when
# wanted: `nix run nixpkgs#statix -- check .`
{
  nixfmt.enable = true;

  deadnix = {
    enable = true;
    # Unused lambda args (`{ config, lib, pkgs, ... }:` with some names
    # unused) are normal NixOS module style; only flag dead let bindings.
    args = [ "--no-lambda-pattern-names" ];
  };

  end-of-file-fixer.enable = true;

  trim-trailing-whitespace = {
    enable = true;
    # Markdown uses trailing double-spaces as line breaks.
    excludes = [ "\\.md$" ];
  };

  check-merge-conflicts.enable = true;
  check-added-large-files.enable = true;
}
