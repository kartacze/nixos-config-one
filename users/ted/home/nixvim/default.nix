{ config, lib, pkgs, inputs, ... }:

let cfg = config.veritas.configs.nixvim;

in {
  imports = [ ./keymaps.nix ./lsp.nix ];

  options.veritas.configs.nixvim = {
    enable = lib.mkEnableOption "neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      colorschemes.dracula.enable = true;

      extraPlugins = with pkgs.vimPlugins; [ vim-nix ];

      clipboard.providers.xclip.enable = true;
      # print("Hello world!")
      extraConfigLua = ''
        -- Print a little welcome message when nvim is opened!
        luasnip = require("luasnip")
      '';

      opts = {
        number = true;
        relativenumber = true;
        shiftwidth = 2;
        ignorecase = true;
        smartcase = true;
      };

      globals.mapleader = " ";

      plugins = {
        lsp-signature = { enable = true; };
        copilot-vim = {
          enable = false;
          # settings = {
          #   panel = {
          #     auto_refresh = true;
          #     enabled = false;
          #   };
          #   suggestion = {
          #     auto_trigger = false;
          #     debounce = 90;
          #     enabled = false;
          #     hide_during_completion = false;
          #     keymap = {
          #       accept_line = false;
          #       accept_word = false;
          #     };
          #   };
          # };
        };

        # copilot-cmp = { enable = true; };
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
        comment.enable = true;

        cmp-nvim-lsp.enable = true;
        cmp-nvim-lua.enable = true;
        luasnip.enable = true;

        cmp-rg = { enable = true; }; # ripgrep cmp
        cmp-buffer = { enable = true; };
        cmp-path = { enable = true; }; # file system paths
        cmp_luasnip = { enable = true; }; # snippets
        cmp-cmdline = { enable = true; };
        cmp-emoji = { enable = true; };

        cmp = {
          enable = true;

          settings = {
            autoEnableSources = true;
            experimental = { ghost_text = true; };
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            snippet = { expand = "luasnip"; };
            formatting = { fields = [ "kind" "abbr" "menu" ]; };

            sources = [
              { name = "nvim_lsp"; }
              { name = "emoji"; }
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
              }
              {
                name = "path"; # file system paths
                keywordLength = 3;
              }
              {
                name = "luasnip"; # snippets
                keywordLength = 3;
              }
              { name = "rg"; }
              { name = "nvim_lua"; }

            ];

            window = {
              completion = { border = "solid"; };
              documentation = { border = "solid"; };
            };

            mapping = {
              "<Tab>" =
                "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-CR>" =
                "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
          };
        };

        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
        };
        oil.enable = true;
        treesitter = {
          enable = true;
          grammarPackages =
            with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
              bash
              json
              lua
              make
              markdown
              nix
              regex
              toml
              vim
              vimdoc
              xml
              yaml
              typescript
              javascript
            ];
        };

        which-key.enable = true;

        bufdelete.enable = true;

        bufferline = {
          enable = true;
          settings = {
            options = {
              offsets = [{
                filetype = "NvimTree";
                text = "File Explorer";
                highlight = "Directory";
                separator = true;
              }];
            };
          };
        };
        lualine.enable = true;

        # efmls-configs = {
        #   enable = true;
        #   setup = {
        #     nix.formatter = [ "nixfmt" ];
        #     typescript.formatter = [ "prettier_d" ];
        #   };
        # };
        nvim-tree = {
          enable = true;
          openOnSetupFile = true;
          view = { width = "30%"; };
        };
        nvim-autopairs.enable = true;
        web-devicons.enable = true;
      };

      autoCmd = [{
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2";
      }];
    };
  };
}
