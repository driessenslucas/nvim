-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")




-- Define necessary functions and variables
_G.molten_warn = function(msg, level, opts)
  vim.notify('[Molten] ' .. msg, level or vim.log.levels.WARN, opts)
end

_G.not_runnable = {
  markdown = true,
  markdown_inline = true,
  yaml = true,
}

_G.get_valid_repl_lang = function()
  local lang = otk.get_current_language_context()
  if not lang or not_runnable[lang] then
    return
  end
  return lang
end

_G.is_overlapped = function(r1, r2)
  return r1.from[1] <= r2.to[1] and r2.from[1] <= r1.to[1]
end

_G.get_overlap = function(r1, r2)
  if is_overlapped(r1, r2) then
    return {
      from = { math.max(r1.from[1], r2.from[1]), 0 },
      to = { math.min(r1.to[1], r2.to[1]), 0 },
    }
  end
end

_G.extract_cells = function(lang, code_chunks, range, partial)
  local chunks = {}

  if partial then
    for _, chunk in ipairs(code_chunks[lang]) do
      local overlap = get_overlap(chunk.range, range)
      if overlap then
        if vim.deep_equal(overlap, chunk.range) then -- full overlap
          table.insert(chunks, chunk)
        else -- partial overlap
          local text = {}
          local lnum_start = overlap.from[1] - chunk.range.from[1] + 1
          local lnum_end = lnum_start + overlap.to[1] - overlap.from[1]
          for i = lnum_start, lnum_end do
            table.insert(text, chunk.text[i])
          end
          table.insert(
            chunks,
            vim.tbl_extend('force', chunk, {
              text = text,
              range = overlap,
            })
          )
        end
      end
    end
  else
    for _, chunk in ipairs(code_chunks[lang]) do
      if is_overlapped(chunk.range, range) then
        table.insert(chunks, chunk)
      end
    end
  end

  return chunks
end

_G.send = function(cell)
  local range = cell.range
  vim.fn.MoltenEvaluateRange(range.from[1] + 1, range.to[1])
end

-- Define the function to run the cell globally
_G.run_cell = function(range)
  local buf = vim.api.nvim_get_current_buf()
  local lang = get_valid_repl_lang() or 'python'

  otk.sync_raft(buf)
  local otk_buf_info = otk._otters_attached[buf]
  if not otk_buf_info then
    molten_warn('code runner not initialized for buffer ' .. buf)
    return
  end

  local filtered = extract_cells(lang, otk_buf_info.code_chunks, range)
  if #filtered == 0 then
    molten_warn('no code found for ' .. lang)
    return
  end
  for _, chunk in ipairs(filtered) do
    send(chunk)
  end
end

-- Define the function to run the current line globally
_G.run_line = function()
  local lang = get_valid_repl_lang()
  if not lang then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(0)

  ---@type code_cell_t
  local cell = {
    lang = lang,
    range = { from = { pos[1] - 1, 0 }, to = { pos[1], 0 } },
    text = vim.api.nvim_buf_get_lines(buf, pos[1] - 1, pos[1], false),
  }

  send(cell)
end

-- Set up a keybinding to run the current line
vim.api.nvim_set_keymap('n', '<leader>rl', ':lua run_line()<CR>', { noremap = true, silent = true })

-- Set up a keybinding to run the current cell
vim.api.nvim_set_keymap('n', '<leader>rc', ':lua run_cell({ from = {vim.fn.line(".") - 1, 0}, to = {vim.fn.line("."), 0} })<CR>', { noremap = true, silent = true })

-- Ensure otk is required correctly
local ok, otk_module = pcall(require, 'otter.keeper')
if ok then
  otk = otk_module
else
  molten_warn('Failed to load otter.keeper')
end
