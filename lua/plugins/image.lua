return{
{
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
        rocks = { "magick" },
    },
},
{
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
    require("image").setup({
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
      backend = "kitty", -- whatever backend you would like to use
      -- max_width = 100,
      -- max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
})
    end
}
}
