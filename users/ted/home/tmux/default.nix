{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.tmux;

in
{
  config = lib.mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      shell = "${pkgs.fish}/bin/fish";
      keyMode = "vi";
      historyLimit = 100000;
      terminal = "tmux-256color";
      extraConfig = ''
        # Truecolor support.
        set -as terminal-overrides ",tmux-256color:RGB"

        # Quiet: no bells, no activity noise.
        set -g visual-activity off
        set -g visual-bell off
        set -g visual-silence off
        setw -g monitor-activity off
        set -g bell-action none
      '';
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
