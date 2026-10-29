{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.agentHost;
  keys = import ../../../lib/keys.nix;
in
{
  config = lib.mkIf cfg.enable {
    # Unprivileged user for unattended agents: no wheel, no access to ted's
    # home or sops secrets. claude-code comes system-wide from
    # machines/shared/claude-code.nix; log in once with `claude /login`.
    # Reach it with `ssh agent@g5555-intel` (tailnet) or `sudo -iu agent`.
    users.users.agent = {
      isNormalUser = true;
      description = "unattended agents";
      shell = pkgs.fish;
      # User services / tmux keep running without an active login.
      linger = true;
      openssh.authorizedKeys.keys = [ keys.main ];
    };

    environment.systemPackages = with pkgs; [
      git
      tmux
    ];
  };
}
