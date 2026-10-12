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
  # NOTE: bat/fd/ripgrep/fzf/direnv/zoxide are managed via their
  # programs.* modules below (shell integration included).
  home.packages = [
    pkgs.gh
    pkgs.htop
    pkgs.diff-so-fancy
    pkgs.vim
    pkgs.jq
    pkgs.tree
    pkgs.watch
    # pkgs.asciinema
    pkgs.nodejs_26
    # pkgs.bun
  ]
  ++ (lib.optionals isDarwin [
    # This is automatically setup on Linux
    pkgs.maven
  ])
  ++ (lib.optionals isLinux [
    pkgs.steam-run
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
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 12;
    };
    keybindings = {
      "super+v" = "paste_from_clipboard";
      "super+c" = "copy_or_interrupt";
      "super+k" = "combine : clear_terminal scroll active : send_text normal,application \\x0c";
      "super+equal" = "increase_font_size";
      "super+minus" = "decrease_font_size";
      "super+0" = "restore_font_size";
      "super+shift+g" = "show_last_command_output";
      "super+ctrl+p" = "scroll_to_prompt -1";
      "super+ctrl+n" = "scroll_to_prompt 1";
    };
    # OneHalf-based theme (was inline in users/ted/kitty, now removed).
    settings = {
      foreground = "#dcdfe4";
      background = "#282c34";
      selection_foreground = "#000000";
      selection_background = "#FFFACD";
      url_color = "#0087BD";
      background_opacity = "0.8";
      color0 = "#282c34";
      color8 = "#5d677a";
      color1 = "#e06c75";
      color9 = "#e06c75";
      color2 = "#98c379";
      color10 = "#98c379";
      color3 = "#e5c07b";
      color11 = "#e5c07b";
      color4 = "#61afef";
      color12 = "#61afef";
      color5 = "#c678dd";
      color13 = "#c678dd";
      color6 = "#56b6c2";
      color14 = "#56b6c2";
      color7 = "#dcdfe4";
      color15 = "#dcdfe4";
    };
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

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
