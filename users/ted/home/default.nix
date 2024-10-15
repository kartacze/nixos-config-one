{ ... }:

{
  imports = [ ./git.nix ./fish/default.nix ];

  veritas.configs = {
    git.enable = true;
    fish.enable = true;
  };
}
