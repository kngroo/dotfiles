return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        blink_cmp = true,
        diffview = true,
        fzf = true,
        gitsigns = true,
        harpoon = true,
        mason = true,
        neotree = true,
        noice = true,
        notify = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
        native_lsp = { enabled = true, underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        } },
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
}
