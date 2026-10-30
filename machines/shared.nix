# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  currentSystemName,
  ...
}:

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

  # Canonical firmware / unfree policy for all NixOS hosts (was copy-pasted
  # into every machines/<host>.nix). enableAllFirmware implies
  # enableRedistributableFirmware; both are kept explicit for readability.
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  # Explicit unfree allowlist instead of blanket allowUnfree. If a rebuild
  # fails with "<pkg> has an unfree license", add `lib.getName pkg` here.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "intel-ocl" # OpenCL runtime via nixos-hardware common-gpu-intel
      "nvidia-settings" # hardware.nvidia.nvidiaSettings GUI (g5555-intel)
      "nvidia-x11" # PRIME driver (g5555-intel)
      "steam" # programs.steam wrapper
      "steam-unwrapped" # programs.steam runtime
      "claude" # nix-claude-code (veritas claudeCode flag)
      "broadcom-bt-firmware"
      "b43-firmware"
      "facetimehd-calibration"
      "facetimehd-firmware"
      "xone-dongle-firmware"
      "nvidia-kernel-modules"
    ];

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
  environment.systemPackages =
    with pkgs;
    [
      libnotify
      glib
      glibc
      gnumake
      gcc
      killall
      vim
      home-manager
      pciutils
      ssh-to-age
      age
      sops
    ]
    # Hosts with veritas firefox get the policy-wrapped one from home-manager.
    ++ lib.optionals (!config.veritas.configs.firefox.enable) [ firefox ]
    ++ lib.optionals config.veritas.configs.desktopApps.enable [
      pavucontrol
      logseq
    ];

  # logseq's electron.
  nixpkgs.config.permittedInsecurePackages = lib.optionals config.veritas.configs.desktopApps.enable [
    "electron-39.8.10"
  ];

  # Enable the OpenSSH daemon (key-only; login passwords are not managed
  # by sops).
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";
}
