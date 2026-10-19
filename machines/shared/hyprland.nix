{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    (lib.mkIf config.veritas.configs.hyprland.enable {
      console.keyMap = "pl2";
      programs.hyprland = {
        enable = true;
        # Plain Hyprland without UWSM: home-manager's
        # wayland.windowManager.hyprland.systemd owns
        # hyprland-session.target / graphical-session.target.
        withUWSM = false;
        xwayland.enable = true;
      };

      # Graphical login (replaces manual `Hyprland` from a TTY).
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${lib.getExe pkgs.tuigreet} --time --remember --background doom --cmd \"start-hyprland\"";
          user = "greeter";
        };
      };

      # programs.light.enable = true;
      programs.thunar.enable = true;
      programs.yazi.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
        ];
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      # GPU-specific vars (WLR_DRM_DEVICES, LIBVA_DRIVER_NAME) are set per-host:
      # Intel-only X1 sets LIBVA_DRIVER_NAME=iHD + WLR_DRM_DEVICES=/dev/dri/card0,
      # NVIDIA PRIME g5555 sets WLR_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0.
      environment.sessionVariables.XDG_SESSION_TYPE = "wayland";
      # Do not force GBM_BACKEND=nvidia-drm / GLX_VENDOR_LIBRARY_NAME=nvidia globally
      # on PRIME offload laptops - it forces everything onto dGPU and breaks Hyprland on iGPU.
      # Launch games explicitly with `nvidia-offload <cmd>` instead.

      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;
        wireplumber.enable = true;
      };
    })

    # 32-bit graphics / audio libs required by Steam. XWayland itself
    # comes from programs.hyprland.xwayland above (no full xserver needed).
    # Single definition — do not repeat enable32Bit in per-host hardware files.
    (lib.mkIf config.veritas.configs.gaming.enable {
      hardware.graphics.enable32Bit = true;
      services.pipewire.alsa.support32Bit = true;
    })
  ];
}
