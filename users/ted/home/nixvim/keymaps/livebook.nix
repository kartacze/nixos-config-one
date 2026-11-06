{
  config,
  lib,
  ...
}:

let
  cfg = config.veritas.configs.nixvim;
in
{
  config = lib.mkIf (cfg.enable && cfg.livebook.enable) {
    programs.nixvim = {
      keymaps = [
        {
          key = "<leader>lr";
          action = "<cmd>LivebookRunCell<cr>";
          options = {
            desc = "Run Cell (Livebook)";
          };
        }
        {
          key = "<leader>lR";
          action = "<cmd>LivebookRunSection<cr>";
          options = {
            desc = "Run Section (Livebook)";
          };
        }
        {
          key = "<leader>la";
          action = "<cmd>LivebookRunAll<cr>";
          options = {
            desc = "Run All Outdated Cells (Livebook)";
          };
        }
        {
          key = "<leader>li";
          action = "<cmd>LivebookInterrupt<cr>";
          options = {
            desc = "Interrupt Cell (Livebook)";
          };
        }
        {
          key = "<leader>lO";
          action = "<cmd>LivebookOutput<cr>";
          options = {
            desc = "Show Cell Output (Livebook)";
          };
        }
        {
          key = "<leader>lo";
          action = "<cmd>LivebookOpen<cr>";
          options = {
            desc = "Open Notebook in Browser (Livebook)";
          };
        }
        {
          key = "<leader>ls";
          action = "<cmd>LivebookSync<cr>";
          options = {
            desc = "Sync Notebook (Livebook)";
          };
        }
      ];
    };
  };
}
