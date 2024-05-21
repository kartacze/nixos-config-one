{ ... }:

{
  imports = [ ./git.nix ];

  veritas.configs = { git.enable = true; };
}
