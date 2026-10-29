# NixOS System Configurations

My NixOS / nix-darwin configurations, managed as a flake. This repository
isn't a turnkey solution for copying my setup or learning Nix — if you wish
to borrow from it, you'll have to learn the basics of Nix, NixOS, flakes,
and Home Manager first.

I don't claim to be an expert, so improvements are welcome — but I value a
working config over an optimal one.

**WARNING: Don't apply this blindly.** This is _my_ configuration (hostnames,
usernames, locale, hardware UUIDs). Read the source before running anything.

## Hosts

| Host | System | User | Description |
| ---- | ------ | ---- | ----------- |
| `g5555-intel` | `x86_64-linux` | `ted`, `agent` | Dell G15, Intel + NVIDIA PRIME, minimal agent host (Hyprland on demand) |
| `latitude-7390` | `x86_64-linux` | `ted` | Dell Latitude 7390 laptop |
| `x1-intel` | `x86_64-linux` | `ted` | ThinkPad X1 Carbon Gen 9 |
| `macbook-pro-m1` | `aarch64-darwin` | `teodorp` | MacBook Pro M1 (nix-darwin) |

Linux hosts run Hyprland + Home Manager; the Mac shares the same Home Manager
CLI tooling (fish + tide, nixvim, tmux, git) via nix-darwin.

## Layout

- `flake.nix` — inputs (`nixpkgs`, `home-manager`, `nixvim`, `hyprland`,
  `nixos-hardware`, `nix-darwin`, `git-hooks`) and one entry per host.
- `lib/mksystem.nix` — builds a host from `machines/<name>.nix`,
  `users/ted/{nixos,darwin}.nix`, and `users/ted/home-manager.nix`.
- `machines/` — per-host files plus `shared.nix` (bootloader, networking,
  locale, base packages) and `shared/` (hyprland, gaming, fonts, …).
- `machines/hardware/` — generated `nixos-generate-config` files plus
  `battery.nix` (power-profiles-daemon + thermald for Intel-only laptops).
- `veritas/` — per-host feature flags (`veritas.configs.*.enable`), declared
  in `modules/veritas-options.nix`. This is where you turn gaming, hyprland,
  ghostty, etc. on/off per machine.
- `users/ted/home/` — one folder per tool (`fish/`, `nixvim/`, `hyprland/`,
  `kitty/`, `ghostty/`, `tmux/`, …), imported from `home/default.nix`.
- `nix/pre-commit.nix` — local-only CI hooks (see below).

## Usage

`NIXNAME` selects the host (defaults to `x86_64-linux` host `x1-intel`):

```
$ NIXNAME=latitude-7390 make switch   # NixOS: nixos-rebuild switch
$ NIXNAME=latitude-7390 make test     # NixOS: build + test without switching
$ NIXNAME=macbook-pro-m1 make switch  # macOS: darwin-rebuild switch
$ make lint                           # flake check + pre-commit hooks
$ make flakeupdate                    # nix flake update
```

## Setup (NixOS)

Install NixOS on the machine by any means (ISO installer is fine), making
sure the disk layout matches `machines/hardware/<name>.nix` (or adjust that
file — it starts as `nixos-generate-config` output). Then:

```
$ git clone <this-repo> && cd <this-repo>
$ NIXNAME=<host> sudo nixos-rebuild switch --flake ".#<host>"
```

Long term this should become `disko` + `nixos-anywhere`; see `upgrades.md`.

## Setup (macOS/Darwin)

Install Nix with the [Determinate installer](https://github.com/DeterminateSystems/nix-installer)
(flake support required; nix-darwin itself is _not_ managing Nix,
see `machines/macbook-pro-m1.nix`). Then:

```
$ git clone <this-repo> && cd <this-repo>
$ NIXNAME=macbook-pro-m1 make switch
```

nix-darwin manages _some_ of the Mac (shell, shared HM tooling) — not apps,
most system settings, or Homebrew.

## Checks (local-only CI)

There is no remote CI by design. `nix develop` installs git-hooks
(nixfmt, deadnix, whitespace hygiene) into `.git/hooks` so every commit is
checked; `make lint` runs `nix flake check --no-build` plus all hooks over
every file. `statix` is intentionally not enforced (its defaults fight NixOS
module idioms) — run it manually: `nix run nixpkgs#statix -- check .`

## Notes

- `system.stateVersion` / `home.stateVersion` stay at their install-time
  values — never bump them on a working system.
- Binary caches / `cachix` push stanzas from the original template are gone;
  all inputs follow a single `nixpkgs` revision (`nix flake update` keeps it
  fresh).
- `upgrades.md` tracks proposed-but-unapplied changes.
