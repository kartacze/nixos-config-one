{ ... }:

{
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
}
