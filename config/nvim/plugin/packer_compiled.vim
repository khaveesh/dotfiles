" Automatically generated packer.nvim plugin loader code

if !has('nvim')
  finish
endif

lua << END
local plugins = {
  ["completion-nvim"] = {
    config = { "\27LJ\2\2\v\0\0\1\0\0\0\1K\0\1\0�\2\1\0\5\0\16\0 6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0029\2\3\0019\2\4\0025\3\6\0009\4\5\0=\4\5\3B\2\2\0019\2\a\0019\2\4\0025\3\b\0009\4\5\0=\4\5\3B\2\2\0019\2\t\0019\2\4\0025\3\n\0009\4\5\0=\4\5\3B\2\2\0019\2\5\0B\2\1\0016\2\v\0009\2\f\0029\2\r\0023\3\15\0=\3\14\2K\0\1\0\0$textDocument/publishDiagnostics\14callbacks\blsp\bvim\1\0\0\25jedi_language_server\1\0\0\vclangd\1\0\0\14on_attach\nsetup\vtexlab\rnvim_lsp\15completion\frequire\0" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/completion-nvim"
  },
  ["glow.nvim"] = {
    commands = { "Glow" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/glow.nvim"
  },
  ["goyo.vim"] = {
    commands = { "Goyo" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/goyo.vim"
  },
  ["limelight.vim"] = {
    commands = { "Goyo" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/limelight.vim"
  },
  ["nord-vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/nord-vim"
  },
  ["nvim-lspconfig"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["pear-tree"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/pear-tree"
  },
  ["srcery-vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/srcery-vim"
  },
  ultisnips = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/ultisnips"
  },
  ["vim-easy-align"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/vim-mundo"
  },
  ["vim-snippets"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/vim-snippets"
  },
  ["vim-you-autocorrect"] = {
    commands = { "EnableAutocorrect" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/vim-you-autocorrect"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      vim._update_package_paths()
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Post-load configuration
-- Config for: nvim-treesitter
require"nvim-treesitter.configs".setup{highlight = {enable = true}}
-- Conditional loads
-- Load plugins in order defined by `after`
vim._update_package_paths()
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads
command! -nargs=* -range -bang -complete=file EnableAutocorrect call s:load(['vim-you-autocorrect'], { "cmd": "EnableAutocorrect", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Glow call s:load(['glow.nvim'], { "cmd": "Glow", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file MundoToggle call s:load(['vim-mundo'], { "cmd": "MundoToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Goyo call s:load(['limelight.vim', 'goyo.vim'], { "cmd": "Goyo", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
  au InsertEnter * ++once call s:load(['nvim-lspconfig', 'pear-tree', 'ultisnips', 'vim-snippets', 'completion-nvim'], { "event": "InsertEnter *" })
augroup END
