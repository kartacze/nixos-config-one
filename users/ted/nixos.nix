{ pkgs, inputs, ... }:

{
  imports = [
    ./nixvim.nix
  ];

  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  programs.tmux.enable = true;

  veritas.configs = {
    nixvim.enable = true;
  };

  users.users.ted = {
    isNormalUser = true;
    home = "/home/ted";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    initialPassword = "qwer1234";
  };
}
