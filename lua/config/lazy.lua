local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
    { import = "lazyvim.plugins.extras.ui.alpha" },
    {
      "goolord/alpha-nvim", -- Dashboard
      event = "VimEnter",
      enabled = true,
      init = false,
      config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = {
          [[                                                                       ]],
          [[  ██████   █████                   █████   █████  ███                  ]],
          [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
          [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
          [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
          [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
          [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
          [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
          [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
          [[                                                                       ]],
          [[                     λ it be like that sometimes λ                     ]]
        }

        dashboard.section.buttons.val = {
          dashboard.button("f", "  Find file", ":Telescope find_files hidden=true no_ignore=true<CR>"),
          dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
          dashboard.button("c", "  Configuration", ":e ~/.config/nvim/init.lua <CR>"),
          dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
          dashboard.button("r", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
          dashboard.button("l", "  Open last session", "<cmd>RestoreSession<CR>"),
          dashboard.button("q", "  Quit", ":qa<CR>")
        }

        local handle, err = io.popen("fortune -s")
        if err or handle == nil then
          dashboard.section.footer.val = "May the truth be found."
          alpha.setup(dashboard.opts)
          return
        end
        local fortune = handle:read("*a")
        handle:close()
        dashboard.section.footer.val = fortune
        alpha.setup(dashboard.opts)
      end
    }
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "slate", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
