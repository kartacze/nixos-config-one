{ ... }:

{
  lib,
  pkgs,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  imports = [ ./home/default.nix ];

  # Pinned to the Home Manager release active at install time. Never bump
  # on a working system without reading the HM release notes — a bump
  # silently changes option defaults (new-version behavior) for all hosts
  # sharing this file.
  home.stateVersion = "24.05";
  programs.zsh.enable = false;

  # NOTE: fish / nixvim are enabled via veritas.configs flags in
  # users/ted/home/{fish,nixvim}/default.nix (controlled per-machine).
  # Do not enable them unconditionally here.

  # xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  # NOTE: bat/fd/ripgrep/fzf/direnv are managed via their
  # programs.* modules below (shell integration included).
  # Directory jumping uses fish's `z` plugin (see home/fish/default.nix),
  # not zoxide.
  home.packages = [
    pkgs.htop
    pkgs.vim
    pkgs.jq
    pkgs.tree
    pkgs.watch
    # Pinned major: Node 26 is required (plain `nodejs` is still 24.x in
    # this nixpkgs). Re-evaluate when nixpkgs promotes a newer default.
    pkgs.nodejs_26
  ]
  ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.maven
  ])
  ++ (lib.optionals isLinux [
    pkgs.steam-run
    pkgs.xclip
    pkgs.dunst
    pkgs.anki-bin
    pkgs.qalculate-qt
    pkgs.wl-clipboard
    pkgs.copyq
    pkgs.cliphist
    pkgs.solaar
    pkgs.brave
    pkgs.rofi
    # NOTE: livebook runs as a systemd user service
    # (machines/shared/livebook.nix), not a home package.
    pkgs.valgrind
    pkgs.zathura
    pkgs.calibre
    pkgs.brightnessctl
    pkgs.lm_sensors
    pkgs.playerctl
    pkgs.megasync
    pkgs.signal-desktop
    pkgs.qimgv
    pkgs.just
    pkgs.freecad-wayland
    pkgs.gimp
    pkgs.pinta
    # pkgs.upower
  ]);

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    # NOTE: no LC_ALL — it overrides every other locale setting and
    # breaks sorting/collation. System locale stays pl_PL.UTF-8.
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };
}
