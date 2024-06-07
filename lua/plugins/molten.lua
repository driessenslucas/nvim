return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    lazy = true,
    config = function()
      local ok, image = pcall(require, "image")
      if ok then
        vim.g.molten_image_provider = "image.nvim"
      end

      vim.g.molten_auto_init_behavior = "init"
      vim.g.molten_enter_output_behavior = "open_and_enter"
      vim.g.molten_output_win_max_height = 100
      vim.g.molten_output_win_cover_gutter = false
      vim.g.molten_output_win_border = "single"
      vim.g.molten_output_win_style = "minimal"
      vim.g.molten_auto_open_output = false
      vim.g.molten_output_show_more = true
      vim.g.molten_virt_text_max_lines = 32
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      local groupid = vim.api.nvim_create_augroup("MoltenSetup", {})

      vim.api.nvim_create_autocmd("BufEnter", {
        desc = "Configure Molten for Python files.",
        pattern = { "*.py", "*.qmd", "*.md", "*.ipynb" },
        group = groupid,
        callback = function()
          vim.g.molten_output_win_border = "single"
          vim.g.molten_virt_lines_off_by_1 = true
          vim.g.molten_virt_text_output = true
        end,
      })

      -- Define the function to run the current line
      local function run_current_line()
        local line_num = vim.api.nvim_win_get_cursor(0)[1]
        vim.fn.MoltenEvaluateRange(line_num, line_num)
        vim.notify("Running current line: " .. line_num, vim.log.levels.INFO)
      end

      local function setup_keymaps()
        local buf = vim.api.nvim_get_current_buf()
        vim.api.set_keymap("n", "<S-5", run_current_line(), { noremap = true, silent = true })
        vim.notify("Molten keymaps set up", vim.log.levels.INFO)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python", "markdown" },
        group = groupid,
        callback = function(info)
          setup_keymaps(info.buf)
        end,
      })

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        setup_keymaps(buf)
      end
    end,
  },
}