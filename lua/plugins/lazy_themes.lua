return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },

  {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
},
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  { "nvimdev/dashboard-nvim", enabled = false },

  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },

}
