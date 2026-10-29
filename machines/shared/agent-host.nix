{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.veritas.configs.agentHost.enable {
    # Keep running with the lid closed; never suspend/hibernate (agents run
    # unattended, reached over the tailnet).
    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
      IdleAction = "ignore";
    };
    systemd.sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowHybridSleep = "no";
      AllowSuspendThenHibernate = "no";
    };

    # Blank the internal panel at the greeter/TTY after 60s.
    boot.kernelParams = [ "consoleblank=60" ];

    # Kill a runaway agent before the whole box locks up (zram is on).
    services.earlyoom.enable = true;

    services.journald.settings.Journal.SystemMaxUse = "1G";
  };
}
