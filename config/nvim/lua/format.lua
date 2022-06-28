-- Run formatters with perfect undo history
return function()
  -- LSP powered formatting
  if vim.b.formatprg == 'lsp' then
    if vim.version().minor == 7 then
      vim.lsp.buf.formatting_sync()
    else
      vim.lsp.buf.format()
    end
  else
    local original_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    local formatted_lines = nil

    if vim.b.formatprg then
      -- Execute shell program and capture stdout
      local function exec_shell(prg)
        formatted_lines = vim.fn.systemlist(prg, formatted_lines or original_lines)
        if vim.v.shell_error ~= 0 then
          error('\n\n' .. table.concat(formatted_lines, '\n') .. '\n')
        end
      end

      if type(vim.b.formatprg[1]) == 'string' then
        exec_shell(vim.b.formatprg)
      else
        vim.tbl_map(exec_shell, vim.b.formatprg)
      end
    else
      -- Trim trailing whitespace and blank lines by default
      formatted_lines = vim.lsp.util.trim_empty_lines(vim.tbl_map(function(line)
        return line:gsub('%s+$', '')
      end, original_lines))
    end

    if not vim.deep_equal(formatted_lines, original_lines) then
      local view = vim.fn.winsaveview()
      vim.api.nvim_buf_set_lines(0, 0, -1, true, formatted_lines)
      vim.fn.winrestview(view)
    end
  end
end
