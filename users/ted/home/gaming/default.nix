{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.gaming;
in
{
  options.veritas.configs.gaming = {
    enable = lib.mkEnableOption "gaming configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-qt
      lutris
      # bottles
      # heroic
    ];

    users.users.ted.extraGroups = [
      "gamemode"
      "input"
    ];
  };
}
