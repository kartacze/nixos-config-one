{ config, lib, pkgs, inputs, ... }:

let cfg = config.veritas.configs.nixvim;

in {
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        nix.enable = true;

        lspkind = {
          enable = true;

          cmp = {
            enable = true;
            menu = {
              nvim_lsp = "[LSP]";
              nvim_lua = "[api]";
              path = "[path]";
              luasnip = "[snip]";
              buffer = "[buffer]";
              neorg = "[neorg]";
            };
          };
        };

        lsp-format = { enable = true; };

        none-ls = {
          enable = true;
          enableLspFormat = true;
          sources = {
            code_actions = { gitsigns.enable = true; };
            formatting = {
              prettierd = {
                enable = true;

                disableTsServerFormatter = true;
              };
              stylua.enable = true;
              nixfmt.enable = true;
            };
            diagnostics = { fish.enable = true; };
          };
        };

        lsp = {

          enable = true;
          servers = {
            ts_ls.enable = true;
            lua_ls.enable = true;
            kotlin_language_server.enable = true;

            tailwindcss = {
              enable = true;
              extraOptions = {
                userLanguages = {
                  elixir = "html-eex";
                  eelixir = "html-eex";
                  heex = "html-eex";
                };
              };
            };

            nixd.enable = true;
            elixirls.enable = true;
            eslint.enable = true;
            html.enable = true;
            # biome.enable = true;
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
              ca = "code_action";
            };
          };
        };
      };
    };
  };
}
