return function(cmds, title)
  local subprocess = require('subprocess')
  local i = 0

  local function on_exit(code, signal, stdout, stderr)
    i = i + 1

    if stdout then
      if i ~= #cmds and stdout[#stdout] ~= '' then stdout[#stdout + 1] = '' end

      vim.schedule(function()
        vim.fn.setloclist(0, {}, 'a', {
          title = title or 'Lint',
          lines = stdout,
        })
        if i == #cmds then vim.cmd('lopen') end
      end)
    end
  end

  vim.fn.setloclist(0, {}, 'f')

  for _, cmd in ipairs(cmds) do
    subprocess({ command = cmd, args = { vim.api.nvim_buf_get_name(0) } }, on_exit)
  end
end
