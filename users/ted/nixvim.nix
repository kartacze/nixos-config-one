{ config, lib, pkgs, ... }:

let cfg = config.veritas.configs.nixvim;

in {
  options.veritas.configs.nixvim = {
    enable = lib.mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.dracula.enable = true;

      extraPlugins = with pkgs.vimPlugins; [ vim-nix ];

      clipboard.providers.xclip.enable = true;
      extraConfigLua = ''
        -- Print a little welcome message when nvim is opened!
        print("Hello world!")
      '';

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
          action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
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
          action = "<cmd>b#|bd#<CR>";
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
      ];

      plugins = {
        gitsigns = {
          enable = true;
          settings = {
            current_line_blame = false;
            current_line_blame_opts = {
              virt_text = true;
              virt_text_pos = "eol";
            };
            signcolumn = true;
            signs = {
              add = { text = "│"; };
              change = { text = "│"; };
              changedelete = { text = "~"; };
              delete = { text = "_"; };
              topdelete = { text = "‾"; };
              untracked = { text = "┆"; };
            };
            watch_gitdir = { follow_files = true; };
          };
        };
        cmp.enable = true;
        cmp-nvim-lsp.enable = true;
        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        bufferline = {
          enable = true;
          offsets = [{
            filetype = "NvimTree";
            text = "File Explorer";
            highlight = "Directory";
            separator = true;
          }];
        };
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
            # lua-ls.enable = true;

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
