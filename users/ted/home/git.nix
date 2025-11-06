{ config, lib, pkgs, ... }:

let cfg = config.veritas.configs.git;

in {
  options.veritas.configs.git = {
    enable = lib.mkEnableOption "git configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ git-absorb ];

    programs.git = {
      enable = true;

      aliases = {
        ci = "commit";
        cim = "commit -m";
        st = "status";
        poh = "push -u origin HEAD";
        pohf = "push -u origin HEAD --force-with-lease";
        co = "checkout";
        cia = "commit --amend";
        br = "branch";
        hist =
          ''log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'';
        lf =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative";
        lfa =
          "log --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative --all";
      };
      userName = "Teodor Pytka";
      userEmail = "teodoreczek@gmail.com";

      extraConfig = {
        core.editor = "nvim";
        core.pager = "diff-so-fancy | less --tabs=4 -RFX";
      };
    };
  };
}
