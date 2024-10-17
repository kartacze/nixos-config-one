{ isWSL, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  imports = [ ./home/default.nix ./nixvim.nix ];
  veritas.configs.nixvim.enable = true;
  home.stateVersion = "24.05";

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
    pkgs.deno

  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
  ]) ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.brave
    pkgs.firefox
    pkgs.rofi
    pkgs.valgrind
    pkgs.zathura
    pkgs.xfce.xfce4-terminal
    pkgs.xautolock

    # move it to nixvim when in home
    pkgs.nixfmt-rfc-style
  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  # home.file.".gdbinit".source = ./gdbinit;
  # home.file.".inputrc".source = ./inputrc;

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
    # "rofi/config.rasi".ext = builtins.readFile ./rofi;
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.bash = {
    enable = true;
    shellOptions = [ ];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;
    shellAliases = { };
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
