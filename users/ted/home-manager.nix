{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

in {

  imports = [ ./home/default.nix ./nixvim.nix ];

  veritas.configs.nixvim.enable = true;

  home.stateVersion = "24.05";

  programs.zsh.enable = true;
  programs.nixvim.enable = true;

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
    pkgs.vim
    pkgs.nodejs
    pkgs.xclip

  ] ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.maven
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

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];

    interactiveShellInit = lib.strings.concatStrings
      (lib.strings.intersperse "\n" ([
        (builtins.readFile ./config.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
      ]));

    shellAliases = {
      vi = "nvim";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";

      jf = "jj git fetch";
      jn = "jj new";
      js = "jj st";
    } // (if isLinux then {
      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    } else
      { });

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

  # programs.gpg.enable = !isDarwin;

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  # xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
