{ pkgs, ... }:

{
  console.keyMap = "pl2";
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = false;
  };

  programs.light.enable = true;
  programs.thunar.enable = true;
  programs.yazi.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
  };
}
