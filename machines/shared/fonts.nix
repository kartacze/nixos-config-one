{ pkgs, ... }:

{
  fonts = {
    # Explicit: default is false, and XWayland clients need the font dir.
    fontDir.enable = true;
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-color-emoji
      pkgs.font-awesome
    ];
  };

  # Icon theme (not a font — lives in system packages, not fonts.packages).
  environment.systemPackages = [ pkgs.papirus-icon-theme ];
}
