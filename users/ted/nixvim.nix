{ config, lib, ... }:

let cfg = config.veritas.configs.nixvim;
in {
  options.veritas.configs.nixvim = {
    enable = lib.mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.gruvbox.enable = true;

      opts = {
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
      ];

      plugins = {
        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        luasnip.enable = true;
        lualine.enable = true;
        efmls-configs = {
          enable = true;
          setup = {
            nix.formatter = [ "nixfmt" ];
            typescript.formatter = [ "prettier_d" ];
          };
        };
        nvim-tree = {
          enable = true;
          openOnSetupFile = true;
        };
        nix.enable = true;

        lsp-format = {
          enable = true;
          lspServersToEnable = [ "efm" ];
        };

        lsp = {

          enable = true;
          servers = {
            efm = {
              enable = true;
              extraOptions.init_options = {
                documentFormatting = true;
                documentRangeFormatting = true;
                hover = true;
                documentSymbol = true;
                codeAction = true;
                completion = true;
              };
            };
            tsserver.enable = true;
            lua-ls.enable = true;
            nixd.enable = true;
            nil_ls.enable = true;
          };
          keymaps = {
            diagnostic = {
              "]d" = "goto_next";
              "[d" = "goto_prev";
            };
            lspBuf = {
              K = "hover";
              gD = "references";
              gd = "definition";
              gi = "implementation";
              gt = "type_definition";
            };
          };
        };
      };

      autoCmd = [{
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2";
      }];
    };
  };
}
