{ inputs, ... }:

{
  imports = [ ./git.nix ./fish/default.nix ./nixvim/default.nix ];

  veritas.configs = {
    git.enable = true;
    nixvim.enable = true;
    fish.enable = false;
  };
}
