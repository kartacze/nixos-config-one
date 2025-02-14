{ config, lib, pkgs, inputs, ... }:

let cfg = config.veritas.configs.nixvim;

in {
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
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
          action = "<cmd>NvimTreeFindFile <CR>";
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
          action = "<cmd>Telescope find_files<CR>";
          key = "<leader>ff";
        }
        {
          action = "<cmd>Telescope lsp_references<CR>";
          key = "gr";
        }
        {
          action = "<cmd>Telescope git_status<CR>";
          key = "<leader>gs";
        }
        {
          action = ''
            <cmd>lua vim.lsp.buf.format({ async = true, filter = function(client) return client.name ~= "ts_ls" end })<CR>";
          '';
          key = "<leader>fm";
        }
        {
          action = "<cmd>BufferLineCycleNext<CR>";
          key = "]b";
        }
        {
          action = "<cmd>BufferLineCyclePrev<CR>";
          key = "[b";
        }
        {
          action = "<cmd>Bdelete<CR>";
          key = "<leader>x";
        }
        {
          action = "<cmd>Gitsigns next_hunk<CR>";
          key = "]c";
        }
        {
          action = "<cmd>Gitsigns prev_hunk<CR>";
          key = "[c";
        }
        {
          action = "<cmd>Gitsigns preview_hunk<CR>";
          key = "<leader>ph";
        }
        {
          action = "<cmd>Gitsigns reset_hunk<CR>";
          key = "<leader>rh";
        }
      ];
    };
  };
}
