{ config, lib, pkgs, ... }:

{
  config = lib.mkMerge [
    {
      console.keyMap = "pl2";
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;

      };

      # programs.light.enable = true;
      programs.thunar.enable = true;
      programs.yazi.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      environment.sessionVariables.WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      environment.sessionVariables.LIBVA_DRIVER_NAME = "";
      environment.sessionVariables.XDG_SESSION_TYPE = "wayland";
      # Do not force GBM_BACKEND=nvidia-drm / GLX_VENDOR_LIBRARY_NAME=nvidia globally
      # on PRIME offload laptops - it forces everything onto dGPU and breaks Hyprland on iGPU.
      # Launch games explicitly with `nvidia-offload <cmd>` instead.

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;
        wireplumber = {
          enable = true;
          package = pkgs.wireplumber;
        };
      };
    }

    # 32-bit graphics / audio / X11 client libs required by Steam.
    (lib.mkIf config.veritas.configs.gaming.enable {
      # Needed even for Wayland-only Hyprland: provides XWayland libs + 32-bit
      # compat required by Steam (X11 client).
      services.xserver.enable = true;
      hardware.graphics.enable32Bit = true;
      services.pipewire.alsa.support32Bit = true;
    })
  ];
}
