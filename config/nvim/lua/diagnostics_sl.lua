-- Statusline diagnostic info
return function()
  local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local sl_error = (e ~= 0) and string.format('%%#ErrorMsg# E:%d ', e) or ''
  local sl_warning = (w ~= 0) and string.format('%%#Search# W:%d ', w) or ''
  vim.b.lsp_sl = sl_error .. sl_warning
end
