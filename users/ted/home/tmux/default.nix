{ config, lib, pkgs, ... }:

let cfg = config.veritas.configs.tmux;

in {
  options.veritas.configs.tmux = {
    enable = lib.mkEnableOption "tmux configuration";
  };

  config = lib.mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      sensibleOnTop = false;
      extraConfig = builtins.readFile ./tmux.conf;
      keyMode = "vi";
      historyLimit = 100000;
      terminal = "screen-256color";
      plugins = with pkgs; [
        # tmuxPlugins.cpu
        # tmuxPlugins.yank
        {
          plugin = tmuxPlugins.dracula;
          extraConfig = ''
               	set -g @dracula-show-battery false
             	set -g @dracula-show-powerline true
             	set -g @dracula-refresh-rate 10
                set -g @dracula-plugins "git mpc time"
            	'';
        }
      ];
    };
  };
}
