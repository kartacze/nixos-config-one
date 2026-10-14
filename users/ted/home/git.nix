{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.git;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ git-absorb ];

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;
      settings = {
        # name = "Teodor Pytka";
        # email = "teodoreczek@gmail.com";
        user = {
          name = "Teodor Pytka";
          email = "teodoreczek@gmail.com";

        };

        alias = {
          ci = "commit";
          cim = "commit -m";
          st = "status";
          poh = "push -u origin HEAD";
          pohf = "push -u origin HEAD --force-with-lease";
          co = "checkout";
          cia = "commit --amend";
          br = "branch";
          hist = ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
          lf = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative";
          lfa = "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative --all";
        };

        core = {
          editor = "nvim";
          # Pager is wired by programs.delta (gitIntegration); diff-so-fancy
          # is unmaintained and no longer installed.
        };
      };
    };
  };
}
