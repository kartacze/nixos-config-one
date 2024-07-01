{ isWSL, ... }:

{ config, lib, pkgs, ... }:

let
  # sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  imports = [ ./home ];

  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "24.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.asciinema
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.diff-so-fancy

    pkgs.gopls
    # pkgs.zigpkgs."0.12.0"

    # Node is required for Copilot.vim
    # pkgs.nodejs
  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.cachix
    pkgs.tailscale
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.chromium
    pkgs.firefox
    pkgs.rofi
    pkgs.valgrind
    pkgs.zathura
    pkgs.xfce.xfce4-terminal
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------


  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      # ga = "git add";
      # gc = "git commit";
      # gcm = "git commit --message";
      # gco = "git checkout";
      # gcp = "git cherry-pick";
      # gdiff = "git diff";
      # gl = "git prettylog";
      # gp = "git push";
      # gs = "git status";
      # gt = "git tag";
    };
  };

  # programs.gpg.enable = !isDarwin;

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
