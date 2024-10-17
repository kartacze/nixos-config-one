{inputs, ... }:

{
  imports = [ ./git.nix ./fish/default.nix ];

  veritas.configs = {
    git.enable = false;
    # nixvim.enable = false;
    fish.enable = false;
  };
}
