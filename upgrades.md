# Proposed upgrades

Status as of 2026-10-12: `nix flake check --no-build` passes with zero warnings.
Already done: WSL host removed, `nix-darwin` flake input added (`lib/mksystem.nix`
uses `inputs.nix-darwin`), Darwin user fixed to `teodorp`, dead `vm-*` hosts
removed, `hardware.opengl` removed, nixvim treesitter migrated to native
`highlight.*` options, `programs.nixvim.nixpkgs.source` set explicitly,
Hyprland Lua config routed through `extraConfig` (systemd hooks active).

Everything below is still open, ordered by priority.

> 2026-10-12 update: points 1–4 are done (single canonical nixpkgs with
> `follows` on all inputs, Electron allowlist deleted, `niv` removed,
> `nixUnstable` → `nixVersions.latest` in `Makefile`). `nix flake check`
> passes with zero warnings.

## P1 – Correctness / hygiene

### 1. Deduplicate nixpkgs (`flake.nix:5`, `flake.lock`)
`flake.nix` uses `github:nixos/nixpkgs/nixos-unstable` (lowercase org, redirect),
which resolves to a channel tarball, while `nixvim`/`home-manager` follow it and
`hyprland` brings its own revision. The lockfile carries two full nixpkgs
(`nixpkgs` tarball + `nixpkgs_2` github), roughly doubling eval closure.
Change to the canonical form so everything resolves to one revision:
```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
```
then `nix flake update`.

### 2. Drop insecure Electron allowlist (`machines/shared.nix:87`)
`nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ]` pins an
EOL Electron. Find the dependent with
`nix why-depends .#nixosConfigurations.x1-intel.config.system.build.toplevel <pkg>`
(suspects in `users/ted/home-manager.nix`: `anki-bin`, `signal-desktop`,
`megasync`), upgrade/replace it, delete the allowlist.

### 3. Remove `niv` (`machines/shared.nix:101`)
Repo is flakes-only; `niv` is unmaintained upstream. Delete from
`environment.systemPackages`.

### 4. `pkgs.nixUnstable` in `Makefile:73`
The `vm/bootstrap0` sed injects `nix.package = pkgs.nixUnstable`, removed from
recent nixpkgs. Use `pkgs.nixVersions.latest` (or `pkgs.nix`).

### 5. Plaintext password hashes in git (`machines/shared.nix:84`, `users/ted/nixos.nix:35`)
Same hash committed twice (user is also defined twice — dedupe to one place,
preferably `users/ted/nixos.nix`). Move secrets to `sops-nix` or `agenix`.

## P2 – Modernization

### 6. Hyprland tracks git main (`flake.nix:17-20`)
`github:hyprwm/Hyprland` without a rev breaks against `nixos-unstable`
frequently and pulls ~15 sub-inputs. Unless git HEAD is needed, drop the input
and use `programs.hyprland` / `pkgs.hyprland` from nixpkgs
(`users/ted/home/hyprland/default.nix:19-21` would simplify to `package = null`
with the NixOS module installing it).

### 7. Replace bespoke GC script with `nix.gc` (`machines/shared.nix:9-16`)
`ted-nix-clean` runs `nix-collect-garbage -d` (deletes everything, no grace
period). Replace with:
```nix
nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 14d"; };
nix.optimise.automatic = true;
```

### 8. Power-management stack fights itself (`machines/hardware/battery.nix`)
Enables `thermald` + `auto-cpufreq` + `system76-scheduler` + `powertop` together
and disables `power-profiles-daemon`. These governors conflict. Pick one stack:
`power-profiles-daemon + thermald` (modern default, integrates with Wayland
desktops) or `tlp`. Also confirm the NVIDIA blacklist in that file is intended
for both importers (`latitude-7390`, `x1-intel` are Intel-only, so it is
harmless but dead weight there).

### 9. `g5555-intel` has no `nixos-hardware` modules (`lib/mksystem.nix:51-62`)
`latitude-7390` and `x1-intel` get hardware profiles; `g5555-intel` (Dell G15
5555, AMD + NVIDIA PRIME) gets none. Add `common-cpu-amd`, `common-gpu-amd`,
`common-gpu-nvidia`, `common-pc-laptop-ssd` (or the closest Dell-G15 profile).
Related: `hardware.cpu.intel.updateMicrocode` is only set for g5555
(`machines/hardware/g5555-intel.nix`); x1 gets it via `common-cpu-intel`,
latitude doesn't set it at all.

### 10. No kernel choice on gaming hosts
All hosts use the default LTS kernel. For `g5555-intel` / `x1-intel` consider
`boot.kernelPackages = pkgs.linuxPackages_latest` (or `_zen`) for newer
graphics/input drivers.

## P3 – Home Manager / UX

### 11. Raw packages instead of HM modules (`users/ted/home-manager.nix:32-48`)
`fzf`, `bat`, `ripgrep`, `fd`, `direnv`, `eza`-class tools are installed as bare
packages, losing shell integration. Use `programs.fzf`, `programs.bat`,
`programs.direnv` (+ `nix-direnv`), `programs.zoxide`, `programs.yazi`, etc.
Same for `nodejs_24` (`:45`): pin per-project via flakes/direnv instead of
globally, or at least track `pkgs.nodejs` (latest LTS).

### 12. Kitty config via `readFile` (`users/ted/home-manager.nix:88-91`)
`extraConfig = builtins.readFile ./kitty` bypasses `programs.kitty` options
(`settings`, `theme`, `font`). Migrate to native options for validation.

### 13. Deduplicate system vs home packages
`brave`, `ghostty`/`kitty`, `xclip` appear in both `machines/shared.nix`
`environment.systemPackages` and HM `home.packages`. Keep GUI/user apps in
home-manager only; keep the system profile minimal.

### 14. Make `--impure` / `ALLOW_UNSUPPORTED` unnecessary (`Makefile:25-36,120`)
Linux `switch`/`test`/`vm/switch` pass `--impure` and
`NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1`, and `NIXNAME ?= dupa` will silently build
a nonexistent config. Set `NIXNAME` default to a real host, move
`allowUnfree` into config (already per-host), drop the env vars. Long term:
replace `make switch/test` with `nh os switch` / `nh darwin switch` (`nh`
also replaces `ted-nix-clean`).

## P4 – Repo health

### 15. No CI (`.github/` has only `images/`)
Add a workflow running `nix flake check --no-build`, plus `statix check`,
`deadnix`, `nixfmt --check`. Add `treefmt` + `git-hooks.nix` devShell to the
flake so formatting/linting runs pre-commit.

### 16. `stateVersion` values are old, leave them
`system.stateVersion = "24.05"` (`machines/shared.nix:123`),
`home.stateVersion = "24.05"` (`users/ted/home-manager.nix:16`),
`system.stateVersion = 5` (darwin, current is 6+ on new installs). Do NOT bump
on existing installs. Any fresh host should use the current release value.

### 17. Declarative disks / bootstrap (`Makefile:53-78`, `machines/hardware/*`)
`vm/bootstrap0` hand-partitions `/dev/sda` with `parted`; hardware files embed
UUIDs. Migrate to `disko` (+ `nixos-anywhere` for remote installs) so new
machines are reproducible from this repo.

### 18. `README.md` is stale
Still documents the Mitchell-Hashimoto VM workflow (`vm-aarch64*`, Parallels/UTM
notes), WSL tarball builds, and `niv` — none of which match this repo anymore
(WSL/`vm-*` removed, ghosts of `NIXNAME=vm-aarch64` in setup guide). Rewrite or
trim to the actual hosts (`g5555-intel`, `latitude-7390`, `x1-intel`,
`macbook-pro-m1`) and the current `make switch/test` flow.
