# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, currentSystemName, ... }:

let

  # Just an example of how to add custom script
  # nix-clean = pkgs.writeShellApplication {
  #   name = "ted-nix-clean";
  #   # runtimeInputs = with pkgs; [ ];
  #   text = ''
  #     sudo nix-env --delete-generations +4
  #     sudo nix-collect-garbage -d
  #   '';
  # };

in
{

  imports = [ ./shared/default.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatic store maintenance (replaces the old `ted-nix-clean` script,
  # which deleted all generations with no grace period).
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise.automatic = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking = {
    # Per-host hostname (g5555-intel, latitude-7390, x1-intel) from
    # lib/mksystem.nix `currentSystemName`; was a static "nixos" on all
    # hosts, which breaks mDNS/DHCP.
    hostName = currentSystemName;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.gvfs.enable = true;

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "pl_PL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure console keymap

  # NOTE: the ted user is defined once in users/ted/nixos.nix.

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # NOTE: user apps (brave, kitty, xclip, ...) live in home-manager
  # (users/ted/home-manager.nix), not here.
  environment.systemPackages = with pkgs; [
    firefox
    libnotify
    glib
    glibc
    pavucontrol
    gnumake
    gcc
    killall
    vim
    home-manager
    pciutils
    ssh-to-age
    passage
    # logseq
    nextcloud-client
  ];

  # Enable the OpenSSH daemon (key-only: passwords are managed via
  # sops-nix, see users/ted/nixos.nix).
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
