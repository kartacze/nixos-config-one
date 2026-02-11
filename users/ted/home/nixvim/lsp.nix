{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.veritas.configs.nixvim;

in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        nix.enable = true;

        lsp-signature.enable = true;
        conform-nvim = {
          enable = true;

          autoInstall.enable = true;
          settings = {
            formatters_by_ft = {
              lua = [ "stylua" ];
              python = [ "isort" "black" ];
              # python = [ "black" ];
              bash = [
                "shellcheck"
                "shellharden"
                "shfmt"
              ];
              cpp = [ "clang_format" ];
              javascript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                timeout_ms = 2000;
                stop_after_first = true;
              };
              "_" = [
                "squeeze_blanks"
                "trim_whitespace"
                "trim_newlines"
              ];
            };
            format_on_save = # Lua
              ''
                function(bufnr)
                  print(bufnr)

                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  -- if slow_format_filetypes[vim.bo[bufnr].filetype] then
                  --   return
                  -- end
                  --
                  -- local function on_format(err)
                  --   if err and err:match("timeout$") then
                  --     slow_format_filetypes[vim.bo[bufnr].filetype] = true
                  --   end
                  -- end

                  return { timeout_ms = 200, lsp_fallback = true }, on_format
                 end
              '';
            format_after_save = # Lua
              ''
                function(bufnr)
                  if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                  end

                  -- if not slow_format_filetypes[vim.bo[bufnr].filetype] then
                  --   return
                  -- end

                  return { lsp_fallback = true }
                end
              '';
            log_level = "warn";
            notify_on_error = true;
            notify_no_formatters = true;
            formatters = {
              black = {
                command = lib.getExe pkgs.black;
              };
              stylua = {
                command = lib.getExe pkgs.stylua;
              };
              shellcheck = {
                command = lib.getExe pkgs.shellcheck;
              };
              shfmt = {
                command = lib.getExe pkgs.shfmt;
              };
              shellharden = {
                command = lib.getExe pkgs.shellharden;
              };
              squeeze_blanks = {
                command = lib.getExe' pkgs.coreutils "cat";
              };
            };
          };
        };

        # none-ls = {
        #   enable = true;
        #   sources = {
        #     code_actions = { gitsigns.enable = true; };
        #     formatting = {
        #       prettierd = {
        #         enable = true;
        #         disableTsServerFormatter = true;
        #       };
        #       stylua.enable = true;
        #       nixfmt.enable = true;
        #       black.enable = true;
        #     };
        #     diagnostics = {
        #       fish.enable = true;
        #       mypy.enable = true;
        #     };
        #   };
        # };

        lsp = {

          enable = true;
          servers = {
            ts_ls = {
              enable = true;
              packageFallback = true;
              settings = {
                single_file_support = false;
              };
            };
            # denols = {
            #   enable = true;
            #   rootDir = ''
            #     require('lspconfig').util.root_pattern("deno.json", "deno.jsonc")
            #   '';
            #
            # };
            lua_ls.enable = true;
            # kotlin_language_server.enable = true;

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
            astro.enable = true;
            # biome.enable = true;
            # nil_ls.enable = true;
            pyright.enable = true;
            pylsp.enable = true;
            stylua.enable = true;
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
              gca = "code_action";
              mr = "rename";
            };
          };
        };
      };
    };
  };
}
