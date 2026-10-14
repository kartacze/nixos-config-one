{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.veritas.configs.fish;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  config = lib.mkIf cfg.enable {
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
        mci = "mvn clean install";
        nrs = "npm run start";
        l = "glow ~/workspace/links.md";
      }
      // (
        if isLinux then
          {
            pbcopy = "wl-copy";
            pbpaste = "wl-paste";
          }
        else
          { }
      );

    };
  };
}
