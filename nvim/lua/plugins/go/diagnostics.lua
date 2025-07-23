local M = {}

-- Diagnostic configuration for go.nvim
M.diagnostic = {
  hdlr = false,
  underline = true,
  virtual_text = {
    spacing = 2,
    prefix = "●",
    -- Only show errors and warnings, hide info/hints
    severity = { min = vim.diagnostic.severity.WARN },
  },
  signs = { "✗", "⚠", "ℹ", "💡" },
  update_in_insert = false,
  severity_sort = true,
}

-- Function to show all diagnostics in popup
function M.show_all_diagnostics()
  -- Close any existing floating windows first
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      pcall(vim.api.nvim_win_close, win, false)
    end
  end

  vim.diagnostic.open_float({
    severity = nil, -- Show ALL diagnostics including hints
    source = "always",
    header = "All Diagnostics (including style checks)",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    prefix = function(diagnostic, i, total)
      local icon = "●"
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        icon = "✗"
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        icon = "⚠"
      elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        icon = "ℹ"
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        icon = "💡"
      end
      return string.format("%s ", icon)
    end,
    suffix = function(diagnostic)
      return string.format(" [%s]", diagnostic.code or "")
    end,
    format = function(diagnostic)
      return string.format("%s", diagnostic.message)
    end,
    max_width = 80,
    wrap = true,
  })
end

-- Function to show only static check warnings
function M.show_static_checks()
  local diagnostics = vim.diagnostic.get(0)
  local static_checks = {}

  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.code and string.match(diagnostic.code, "^ST%d+") then
      table.insert(static_checks, diagnostic)
    end
  end

  if #static_checks > 0 then
    local lines = { "Static Check Warnings:" }
    for _, diagnostic in ipairs(static_checks) do
      table.insert(
        lines,
        string.format("• [%s] %s (line %d)", diagnostic.code, diagnostic.message, diagnostic.lnum + 1)
      )
    end

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
      title = "Go Static Checks",
      timeout = 5000,
    })
  else
    vim.notify("No static check warnings found", vim.log.levels.INFO)
  end
end

-- Function to browse diagnostics with telescope or quickfix
function M.browse_diagnostics()
  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  if telescope_ok then
    telescope.diagnostics({ bufnr = 0 })
  else
    -- Fallback to quickfix
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      vim.notify("No diagnostics found", vim.log.levels.INFO)
      return
    end

    local items = {}
    for _, diagnostic in ipairs(diagnostics) do
      local severity_name = ({
        [vim.diagnostic.severity.ERROR] = "ERROR",
        [vim.diagnostic.severity.WARN] = "WARN",
        [vim.diagnostic.severity.INFO] = "INFO",
        [vim.diagnostic.severity.HINT] = "HINT",
      })[diagnostic.severity] or "UNKNOWN"

      table.insert(items, {
        filename = vim.api.nvim_buf_get_name(0),
        lnum = diagnostic.lnum + 1,
        col = diagnostic.col + 1,
        text = string.format("[%s] %s %s", diagnostic.code or "", severity_name, diagnostic.message),
      })
    end

    vim.fn.setqflist(items)
    vim.cmd("copen")
  end
end

-- Setup diagnostic keymaps
function M.setup_keymaps()
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- Diagnostic keymaps
  map("n", "<leader>Gx", M.show_all_diagnostics, { desc = "Show All Diagnostics" })
  map("n", "<leader>GX", M.show_static_checks, { desc = "Show Static Check Warnings" })
  map("n", "<leader>GD", M.browse_diagnostics, { desc = "Browse All Diagnostics" })
end

return M
