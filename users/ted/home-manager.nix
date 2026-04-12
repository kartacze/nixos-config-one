{ isWSL, ... }:

{
  lib,
  pkgs,
  ...
}:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [ ./home/default.nix ];
  home.stateVersion = "24.05";
  programs.zsh.enable = false;

  programs.fish.enable = true;
  programs.nixvim.enable = true;

  # xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.diff-so-fancy
    pkgs.vim
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    # pkgs.asciinema
    pkgs.bat
    pkgs.fd
    pkgs.nodejs_24
    pkgs.direnv
    # pkgs.bun
    pkgs.steam-run
  ]
  ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.maven
  ])
  ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.ghostty
    pkgs.xclip
    pkgs.pipewire
    pkgs.dunst
    pkgs.anki-bin
    pkgs.qalculate-qt
    pkgs.wl-clipboard
    pkgs.copyq
    pkgs.cliphist
    pkgs.solaar
    pkgs.brave
    pkgs.rofi
    pkgs.livebook
    pkgs.valgrind
    pkgs.zathura
    pkgs.calibre
    pkgs.brightnessctl
    # move it to nixvim when in home
    # pkgs.nixfmt
    pkgs.megasync
    pkgs.signal-desktop
    pkgs.qimgv
    # pkgs.upower
  ]);

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };
}
