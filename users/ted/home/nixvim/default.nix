{ config, lib, pkgs, ... }:

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
        -- luasnip = require("luasnip")
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

        render-markdown = { enable = true; };
        trouble.enable = true;
        colorizer.enable = true;
        friendly-snippets.enable = true;

        blink-cmp = {
          enable = true;

          settings.appearance.kind_icons = {
            Class = "󱡠";
            Color = "󰏘";
            Constant = "󰏿";
            Constructor = "󰒓";
            Enum = "󰦨";
            EnumMember = "󰦨";
            Event = "󱐋";
            Field = "󰜢";
            File = "󰈔";
            Folder = "󰉋";
            Function = "󰊕";
            Interface = "󱡠";
            Keyword = "󰻾";
            Method = "󰊕";
            Module = "󰅩";
            Operator = "󰪚";
            Property = "󰖷";
            Reference = "󰬲";
            Snippet = "󱄽";
            Struct = "󱡠";
            Text = "󰉿";
            TypeParameter = "󰬛";
            Unit = "󰪚";
            Value = "󰦨";
            Variable = "󰆦";
          };

        };

        snacks = {
          enable = true;
          settings = {
            image = { enabled = true; };
            notifier = { enabled = true; };
            picker = { enabled = true; };
            explorer = { enabled = true; };
            bufdelete = { enabled = true; };
            dim = { enabled = true; };
            git = { enabled = true; };
            indent = { enabled = true; };
            scope = { enabled = true; };
            scratch = { enabled = true; };
            toggle = { enabled = true; };
            words = { enabled = true; };
          };
        };
        #  this could be replaced with folde/snacks.image
        # image = { enable = true; };

        mini = {
          enable = true;
          modules = {
            ai = {
              n_lines = 50;
              search_method = "cover_or_next";
            };
            diff = { view = { style = "sign"; }; };
            pairs = {
              modes = {
                insert = true;
                command = false;
                terminal = false;
              };
            };
            splitjoin = { };
            tabline = { };
            icons = { };
            notify = { };
            indentscope = { };
            cursorword = { };
            jump = { };
            bracketed = { };

            # snippets = {
            #   settings = {
            #     snippets = {
            #       "__raw" = "require('mini.snippets').gen_loader.from_lang()";
            #     };
            #   };
            # };
            # completion = { };
            # comment = {
            #   mappings = {
            #     comment = "<leader>/";
            #     comment_line = "<leader>/";
            #     comment_visual = "<leader>/";
            #     textobject = "<leader>/";
            #   };
            # };
            starter = {
              content_hooks = {
                "__unkeyed-1.adding_bullet" = {
                  __raw = "require('mini.starter').gen_hook.adding_bullet()";
                };
                "__unkeyed-2.indexing" = {
                  __raw =
                    "require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' })";
                };
                "__unkeyed-3.padding" = {
                  __raw =
                    "require('mini.starter').gen_hook.aligning('center', 'center')";
                };
              };
              evaluate_single = true;
              header = ''
                ______ __________________________       ________________        ______
                ___  / ___  ____/___  __/__  ___/       __  ____/__  __ \       ___  /
                __  /  __  __/   __  /   _____ \        _  / __  _  / / /       __  / 
                _  /____  /___   _  /    ____/ /        / /_/ /  / /_/ /         /_/  
                /_____//_____/   /_/     /____/         \____/   \____/         (_)   
              '';
              items = {
                "__unkeyed-1.buildtin_actions" = {
                  __raw = "require('mini.starter').sections.builtin_actions()";
                };
                "__unkeyed-2.recent_files_current_directory" = {
                  __raw =
                    "require('mini.starter').sections.recent_files(10, false)";
                };
                "__unkeyed-3.recent_files" = {
                  __raw =
                    "require('mini.starter').sections.recent_files(10, true)";
                };
                "__unkeyed-4.sessions" = {
                  __raw = "require('mini.starter').sections.sessions(5, true)";
                };
              };
              operators = { };
            };

            surround = {
              custom_surroundings = null;
              highlight_duration = 500;

              mappings = {
                add = "sa";
                delete = "sd";
                find = "sf";
                find_left = "sF";
                highlight = "sh";
                replace = "sr";
                suffix_last = "l";
                suffix_next = "n";
              };
            };
          };
        };

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

        comment = {
          enable = true;
          settings = {
            pre_hook =
              "require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()";
          };
        };

        ts-comments.enable = true;
        ts-context-commentstring.enable = true;

        # cmp-nvim-lsp.enable = true;
        # cmp-nvim-lua.enable = true;
        # luasnip.enable = true;

        # cmp-rg = { enable = true; }; # ripgrep cmp
        # cmp-buffer = { enable = true; };
        # cmp-path = { enable = true; }; # file system paths
        # cmp_luasnip = { enable = true; }; # snippets
        # cmp-cmdline = { enable = true; };
        # cmp-emoji = { enable = true; };

        # cmp = {
        #   enable = true;
        #
        #   settings = {
        #     autoEnableSources = true;
        #     experimental = { ghost_text = true; };
        #     performance = {
        #       debounce = 60;
        #       fetchingTimeout = 200;
        #       maxViewEntries = 30;
        #     };
        #     snippet = { expand = "luasnip"; };
        #     formatting = { fields = [ "kind" "abbr" "menu" ]; };
        #
        #     sources = [
        #       { name = "nvim_lsp"; }
        #       { name = "emoji"; }
        #       {
        #         name = "buffer"; # text within current buffer
        #         option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
        #         keywordLength = 3;
        #       }
        #       {
        #         name = "path"; # file system paths
        #         keywordLength = 3;
        #       }
        #       {
        #         name = "luasnip"; # snippets
        #         keywordLength = 3;
        #       }
        #       { name = "rg"; }
        #       { name = "nvim_lua"; }
        #
        #     ];
        #
        #     window = {
        #       completion = { border = "solid"; };
        #       documentation = { border = "solid"; };
        #     };
        #
        #     mapping = {
        #       "<Tab>" =
        #         "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        #       "<C-j>" = "cmp.mapping.select_next_item()";
        #       "<C-k>" = "cmp.mapping.select_prev_item()";
        #       "<C-e>" = "cmp.mapping.abort()";
        #       "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        #       "<C-f>" = "cmp.mapping.scroll_docs(4)";
        #       "<C-Space>" = "cmp.mapping.complete()";
        #       "<CR>" = "cmp.mapping.confirm({ select = true })";
        #       "<S-CR>" =
        #         "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
        #     };
        #   };
        # };

        telescope = {
          enable = true;
          extensions.fzf-native.enable = true;
        };

        # oil.enable = true;
        # treesitter = {
        #   enable = true;
        #   settings = {
        #     auto_install = false;
        #     ensure_installed = "all";
        #     highlight = {
        #       additional_vim_regex_highlighting = true;
        #       custom_captures = { };
        #       disable = [ "rust" ];
        #       enable = true;
        #     };
        #     ignore_install = [ "rust" "ipkg" ];
        #     incremental_selection = {
        #       enable = true;
        #       keymaps = {
        #         init_selection = false;
        #         node_decremental = "grm";
        #         node_incremental = "grn";
        #         scope_incremental = "grc";
        #       };
        #     };
        #     indent = { enable = true; };
        #     sync_install = false;
        #   };
        #
        #   grammarPackages =
        #     with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        #       bash
        #       json
        #       lua
        #       make
        #       markdown
        #       nix
        #       regex
        #       toml
        #       vim
        #       vimdoc
        #       xml
        #       yaml
        #       elixir
        #       erlang
        #       typescript
        #       javascript
        #       kotlin
        #       java
        #     ];
        # };

        which-key.enable = true;

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
        nvim-tree = {
          enable = true;
          openOnSetupFile = true;
          settings = { view = { width = "30%"; }; };
        };
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
