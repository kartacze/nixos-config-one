{ pkgs, inputs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  environment.pathsToLink = [ "/share/fish" ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Since we're using fish as our shell
  programs.fish.enable = true;

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;

    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    globals.mapleader = " ";

    keymaps = [
      {
        action = "<cmd>Telescope live_grep<CR>";
	key = "<leader>g";
      }
    ];

    plugins = {
       telescope.enable = true;
       oil.enable = true;
       treesitter.enable = true;
       luasnip.enable = true;
       lualine.enable = true;
       nvim-tree = {
         enable = true;
	 openOnSetupFile = true;
       };

       lsp = {
         enable = true;
	 servers = {
           tsserver.enable = true;
	   lua-ls.enable = true;
	   nixd.enable = true;
	 };
       };
    };
  };

  users.users.ted = {
    isNormalUser = true;
    home = "/home/ted";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    initialPassword = "qwer1234";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGbTIKIPtrymhvtTvqbU07/e7gyFJqNS4S0xlfrZLOaY mitchellh"
    ];
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [
    (import ./vim.nix { inherit inputs; })
  ];
}
