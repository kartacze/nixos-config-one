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

  # Plaintext credentials have been committed before (see users/ted/databaseUrl
  # history) — fail commits containing secrets or private keys.
  # NOTE: this git-hooks revision has no `gitleaks` hook yet (it appears
  # upstream after 2026-09-27); trufflehog covers the same ground.
  trufflehog.enable = true;
  detect-private-keys.enable = true;

  # Lua (Hyprland config) must stay formatted.
  stylua.enable = true;

  # YAML sanity (.sops.yaml lives here). No check-json: the only JSONC
  # file (waybar config) has comments, which strict JSON checkers reject.
  check-yaml.enable = true;

  mixed-line-endings.enable = true;
  forbid-new-submodules.enable = true;

  # Deliberately absent:
  # - shellcheck/shfmt: no POSIX shell sources in tree (only fish/config.fish,
  #   which neither tool parses — shellcheck would false-positive, shfmt -w
  #   would corrupt it).
  # - markdownlint: current docs intentionally violate its defaults (long
  #   lines, $-prefixed shell snippets); enforcing it means a doc rewrite.
}
