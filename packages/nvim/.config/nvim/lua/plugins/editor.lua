return {
  -- Undo history as a browsable tree. LazyVim already sets undofile=true and
  -- undolevels=10000, so this history persists across sessions.
  -- <leader>u is LazyVim's UI-toggle group, so this lives on <leader>U.
  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    keys = {
      { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 36
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_ShortIndicators = 1
    end,
  },

  -- The Cmd+D replacement.
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "Add cursor at next match" },
      { "<C-p>", mode = { "n", "x" }, desc = "Skip to next match" },
      { "<M-n>", mode = { "n", "x" }, desc = "Add cursor at prev match" },
      { "<M-Down>", mode = { "n", "x" }, desc = "Add cursor below" },
      { "<M-Up>", mode = { "n", "x" }, desc = "Add cursor above" },
      { "<leader>A", mode = { "n", "x" }, desc = "Cursor on every match" },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local set = vim.keymap.set

      -- Cmd+D equivalent: add a cursor at the next occurrence of the word
      -- under the cursor (or the visual selection).
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Add cursor at next match" })
      set({ "n", "x" }, "<M-n>", function() mc.matchAddCursor(-1) end, { desc = "Add cursor at prev match" })
      set({ "n", "x" }, "<C-p>", function() mc.matchSkipCursor(1) end, { desc = "Skip to next match" })
      set({ "n", "x" }, "<leader>A", function() mc.matchAllAddCursors() end, { desc = "Cursor on every match" })

      -- Column cursors. <C-Up>/<C-Down> are LazyVim's window-resize keys,
      -- so these live on Alt-arrows instead.
      set({ "n", "x" }, "<M-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
      set({ "n", "x" }, "<M-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })

      -- Layer active only while multiple cursors exist.
      mc.addKeymapLayer(function(layerSet)
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)
        layerSet("n", "<leader>x", mc.deleteCursor)
        -- First <esc> clears the cursors, second behaves normally.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
  },

  -- <leader>m toggles a block between one-line and multi-line.
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Split/Join Block" },
    },
    opts = { use_default_keymaps = false, max_join_length = 160 },
  },

  -- Branch / PR review inside nvim. gitsigns (LazyVim) covers per-hunk work.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: working tree" },
      { "<leader>gD", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: this file's history" },
      { "<leader>gm", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "Diffview: vs merge base" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },

  -- Align on a delimiter: gaip= aligns a paragraph on '='.
  -- The maintained successor to junegunn/vim-easy-align.
  { "nvim-mini/mini.align", event = "VeryLazy", opts = {} },
}
