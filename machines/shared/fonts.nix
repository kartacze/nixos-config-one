{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = [
      # pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-emoji
      pkgs.font-awesome
      pkgs.papirus-icon-theme
    ];
  };
}
