# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let linuxGnome = false;

in {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.livebook = {
    enableUserService = true;
    package = pkgs.livebook;
    extraPackages = with pkgs; [ gcc gnumake ];
    environmentFile = "/var/lib/livebook.env";
  };

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

  services.xserver = if linuxGnome then {
    enable = true;
    layout = "pl";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  } else {
    enable = true;
    xkb.layout = "pl";
    dpi = 96;

    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };

    displayManager = {
      # defaultSession = "none+i3";
      lightdm.enable = true;

      # AARCH64: For now, on Apple Silicon, we must manually set the
      # display resolution. This is a known issue with VMware Fusion.
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 40
        ${pkgs.xorg.xrandr}/bin/xrandr -s '2048x1152'
      '';
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status i3lock i3blocks ];
    };
  };

  services.displayManager =
    if !linuxGnome then { defaultSession = "none+i3"; } else { };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [ jetbrains-mono fira-code fira-mono ];
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ted = {
    isNormalUser = true;
    description = "ted";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword =
      "$y$j9T$D7FDR5mTReMHtGsU4t0sG1$i9C6ltgqCy7VD7/zwA2t0r/GjYzNd4omdGZOaWjHFR9";
  };

  # Install firefox.
  programs.thunar.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [ "electron-27.3.11" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pavucontrol
    gnumake
    killall
    niv
    xclip
    vim
    kitty
    home-manager
    pciutils
    logseq
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
