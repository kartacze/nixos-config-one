# Proposed upgrades

Status as of 2026-10-12: `nix flake check --no-build` passes with zero warnings.

Already completed: WSL host removed; `nix-darwin` flake input added; Darwin user
fixed to `teodorp`; dead `vm-*` hosts removed; `hardware.opengl` removed; nixvim
treesitter migrated to native options; `programs.nixvim.nixpkgs.source` set;
Hyprland Lua config via `extraConfig`; single canonical nixpkgs with `follows`
on all inputs; Electron allowlist deleted; `niv` removed; `nixUnstable` fixed;
`nix.gc`/`optimise` replace `ted-nix-clean`; `battery.nix` is PPD + thermald;
`g5555-intel` gets generic nixos-hardware modules; gaming hosts on
`linuxPackages_latest`; `bat`/`fd`/`ripgrep`/`fzf`/`direnv`/`zoxide` via
`programs.*`; kitty config native in `users/ted/home/kitty/`; system/home
packages deduped; `Makefile` cleaned (`NIXNAME ?= x1-intel`, no
`ALLOW_UNSUPPORTED_SYSTEM`); local-only CI via `git-hooks.nix` + `make lint`
(`nix/pre-commit.nix`: nixfmt, deadnix, whitespace hygiene — no remote CI by
design; statix stays manual since its ruleset conflicts with NixOS idioms);
`README.md` rewritten for the actual hosts and workflow; `sops-nix` is
wired up for optional secrets (`secrets/ted.yaml` is encrypted, `.sops.yaml`
holds the recipients); the `ted` login password is not stored in sops; each
host uses its own hostname (`currentSystemName`); SSH is key-only
(`PasswordAuthentication = false`); `LC_ALL` removed from home session vars.

Everything below is still open, ordered by priority.

## P1 – Correctness / hygiene

(nothing open)

## P2 – Modernization

### 2. Hyprland tracks git main (`flake.nix`) — DONE
Dropped the `github:hyprwm/Hyprland` input; Hyprland + portal now come from
nixpkgs (`programs.hyprland` on NixOS, HM defaults at home level).
