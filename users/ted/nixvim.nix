{
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
      {
        action = "<cmd>NvimTreeToggle<CR>";
	key = "<C-n>";
      }
      {
        action = "<cmd>NvimTreeFocus<CR>";
	key = "<leader>e";
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
	key = "<leader>fw";
      }
      {
        action = "<cmd>Telescope find_files<CR>";
	key = "<leader>ff";
      }
      {
        action = "<cmd>Telescope lsp_definitions<CR>";
	key = "<leader>gd";
      }
      {
        action = "<cmd>Telescope lsp_references<CR>";
	key = "<leader>gr";
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
}
