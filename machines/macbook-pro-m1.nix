{ pkgs, ... }:

{
  # Veritas flags live in veritas/macbook-pro-m1.nix (applied by lib/mksystem.nix).

  # We install Nix using a separate installer so we don't want nix-darwin
  # to manage it for us. This tells nix-darwin to just use whatever is running.
  nix.enable = false;

  nix.package = pkgs.nix;

  # Keep in sync with shared NixOS settings (machines/shared.nix
  # `nix.settings`). nix-darwin does not manage Nix itself here (Determinate
  # installer does), so only client settings are declared.
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    keep-outputs = true;
    keep-derivations = true;
  };

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  # The user `darwin-rebuild` runs as. Required by any nix-darwin option
  # that still applies per-user (see `system.requiresPrimaryUser`); also
  # gates the primary-user activation check.
  system.primaryUser = "teodorp";

  programs.fish.enable = true;
  programs.fish.shellInit = ''
    # Nix
    if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
      source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
    end
    # End Nix
  '';

  environment.shells = with pkgs; [
    bashInteractive
    fish
  ];
  # environment.shells = with pkgs; [ bashInteractive zsh fish ];
  # environment.systemPackages = with pkgs; [ cachix ];
}
