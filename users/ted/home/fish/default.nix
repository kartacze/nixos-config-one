{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.fish;
  isLinux = pkgs.stdenv.isLinux;
in
{
  options.veritas.configs.fish = {
    enable = lib.mkEnableOption "fish configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ zoxide ];

    programs.fish = {
      enable = true;

      plugins = [
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];

      interactiveShellInit = lib.strings.concatStrings (
        lib.strings.intersperse "\n" [
          (builtins.readFile ./config.fish)
          "set -g SHELL ${pkgs.fish}/bin/fish"
        ]
      );

      shellAliases = {
        vi = "nvim";
        ga = "git add";
        gc = "git commit";
        gco = "git checkout";
        gcp = "git cherry-pick";
        gdiff = "git diff";
        gl = "git prettylog";
        gp = "git push";
        gs = "git status";
        gt = "git tag";

        jf = "jj git fetch";
        jn = "jj new";
        js = "jj st";
        oc = "steam-run opencode";
      }
      // (
        if isLinux then
          {
            # Two decades of using a Mac has made this such a strong memory
            # that I'm just going to keep it consistent.
            pbcopy = "xclip";
            pbpaste = "xclip -o";
          }
        else
          { }
      );

    };
  };
}
