{ config, pkgs, lib, ... }: {
  imports = [ ./hardware/g5555-intel.nix ./shared.nix ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Lots of stuff that uses aarch64 that claims doesn't work, but actually works.
  nixpkgs.config.allowUnfree = true;

  # This works through our custom module imported above

}
