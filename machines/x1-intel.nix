{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/x1-intel.nix ./shared.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = false;
  };

  programs.light.enable = true;

  # services.displayManager.ly = {
  #   enable = true;
  #   settings = {
  #     load = false;
  #     save = false;
  #
  #   };
  #   # autoLogin = true;
  #   # wayland = true;
  # };

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # This works through our custom module imported above

}
