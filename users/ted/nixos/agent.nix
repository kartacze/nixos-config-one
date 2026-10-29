{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.agentHost;
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
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5X3sPc15vP/7Us0WVa/3+amgFyfueQZjhQ3KWal3aJ teodor.pytka@gmail.com"
      ];
    };

    environment.systemPackages = with pkgs; [
      git
      tmux
    ];
  };
}
