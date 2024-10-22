{inputs, ... }:

{
  imports = [ ./git.nix ./fish/default.nix ];

  veritas.configs = {
    git.enable = true;
    # nixvim.enable = true;
    fish.enable = false;
  };
}
