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
    # OneHalf Dark via kitty-themes (was an inline palette before).
    themeFile = "OneHalfDark";
    settings = {
      background_opacity = 0.8;
    };
  };
}
