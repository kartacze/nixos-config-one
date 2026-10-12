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
design; statix stays manual since its ruleset conflicts with NixOS idioms).

Everything below is still open, ordered by priority.

## P1 – Correctness / hygiene

### 1. Plaintext password hashes in git (`machines/shared.nix`, `users/ted/nixos.nix`)
Same hash committed twice (user is also defined twice — dedupe to one place,
preferably `users/ted/nixos.nix`). Move secrets to `sops-nix` or `agenix`.

## P2 – Modernization

### 2. Hyprland tracks git main (`flake.nix`)
`github:hyprwm/Hyprland` without a rev breaks against `nixos-unstable`
frequently and pulls ~15 sub-inputs. Unless git HEAD is needed, drop the input
and use `programs.hyprland` / `pkgs.hyprland` from nixpkgs
(`users/ted/home/hyprland/default.nix` package/portalPackage would simplify to
`null` with the NixOS module installing it).

## P3 – Repo health

### 3. `stateVersion` values are old, leave them
`system.stateVersion = "24.05"` (`machines/shared.nix`),
`home.stateVersion = "24.05"` (`users/ted/home-manager.nix`),
`system.stateVersion = 5` (darwin, current is 6+ on new installs). Do NOT bump
on existing installs. Any fresh host should use the current release value.

### 4. Declarative disks / bootstrap (`Makefile`, `machines/hardware/*`)
`vm/bootstrap0` hand-partitions `/dev/sda` with `parted`; hardware files embed
UUIDs. Migrate to `disko` (+ `nixos-anywhere` for remote installs) so new
machines are reproducible from this repo.

### 5. `README.md` is stale
Still documents the Mitchell-Hashimoto VM workflow (`vm-aarch64*`, Parallels/UTM
notes), WSL tarball builds, and `niv` — none of which match this repo anymore
(WSL/`vm-*` removed, ghosts of `NIXNAME=vm-aarch64` in setup guide). Rewrite or
trim to the actual hosts (`g5555-intel`, `latitude-7390`, `x1-intel`,
`macbook-pro-m1`) and the current `make switch/test` flow.
