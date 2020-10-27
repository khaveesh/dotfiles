" Automatically generated packer.nvim plugin loader code

if !has('nvim')
  finish
endif

lua << END
local plugins = {
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
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/packer.nvim"
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
loadstring("\27LJ\2\2Ç\5\0\0\5\0\"\0%6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\0015\2\v\0005\3\b\0005\4\t\0=\4\n\3=\3\f\0025\3\r\0005\4\14\0=\4\15\0035\4\16\0=\4\17\3=\3\18\0025\3\19\0005\4\20\0=\4\21\0035\4\22\0=\4\23\0035\4\24\0=\4\25\0035\4\26\0=\4\27\3=\3\28\0025\3\29\0005\4\30\0=\4\31\3=\3 \2=\2!\1B\0\2\1K\0\1\0\16textobjects\16lsp_interop\25peek_definition_code\1\0\2\agK\17@class.outer\agk\20@function.outer\1\0\1\venable\2\tmove\22goto_previous_end\1\0\1\a[M\20@function.outer\24goto_previous_start\1\0\1\a[m\20@function.outer\18goto_next_end\1\0\1\a]M\20@function.outer\20goto_next_start\1\0\1\a]m\20@function.outer\1\0\1\venable\2\tswap\18swap_previous\1\0\1\n<C-h>\21@parameter.inner\14swap_next\1\0\1\n<C-l>\21@parameter.inner\1\0\1\venable\2\vselect\1\0\0\fkeymaps\1\0\4\aif\20@function.inner\aaf\20@function.outer\aac\17@class.outer\aic\17@class.inner\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\4\0\0\6c\bcpp\vpython\nsetup\28nvim-treesitter.configs\frequire\0")()
-- Config for: completion-nvim
loadstring("\27LJ\2\2\v\0\0\1\0\0\0\1K\0\1\0ï\2\1\0\b\0\24\0+6\0\0\0'\1\1\0B\0\2\0026\1\0\0'\2\2\0B\1\2\0029\2\3\0019\2\4\0025\3\f\0005\4\n\0005\5\b\0005\6\6\0005\a\5\0=\a\a\6=\6\t\5=\5\v\4=\4\r\0039\4\14\0B\4\1\2=\4\14\3B\2\2\0019\2\15\0019\2\4\0025\3\16\0009\4\14\0B\4\1\2=\4\14\3B\2\2\0019\2\17\0019\2\4\0025\3\18\0009\4\14\0B\4\1\2=\4\14\3B\2\2\0019\2\14\0B\2\1\0016\2\19\0009\2\20\0029\2\21\0023\3\23\0=\3\22\2K\0\1\0\0$textDocument/publishDiagnostics\14callbacks\blsp\bvim\1\0\0\25jedi_language_server\1\0\0\vclangd\14on_attach\rsettings\1\0\0\nlatex\1\0\0\nbuild\1\0\0\targs\1\0\0\1\2\0\0\14-lualatex\nsetup\vtexlab\rnvim_lsp\15completion\frequire\0")()
-- Config for: gitsigns.nvim
loadstring("\27LJ\2\2Ñ\1\0\0\4\0\16\0\0196\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\14\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\0025\3\b\0=\3\t\0025\3\n\0=\3\v\0025\3\f\0=\3\r\2=\2\15\1B\0\2\1K\0\1\0\nsigns\1\0\0\17changedelete\1\0\1\ttext\6_\14topdelete\1\0\1\ttext\6^\vdelete\1\0\1\ttext\6-\vchange\1\0\1\ttext\6~\badd\1\0\0\1\0\1\ttext\6+\nsetup\rgitsigns\frequire\0")()
-- Conditional loads
-- Load plugins in order defined by `after`
vim._update_package_paths()
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads
command! -nargs=* -range -bang -complete=file EnableAutocorrect call s:load(['vim-you-autocorrect'], { "cmd": "EnableAutocorrect", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file MundoToggle call s:load(['vim-mundo'], { "cmd": "MundoToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })
command! -nargs=* -range -bang -complete=file Goyo call s:load(['limelight.vim', 'goyo.vim'], { "cmd": "Goyo", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
  au InsertEnter * ++once call s:load(['ultisnips', 'vim-snippets'], { "event": "InsertEnter *" })
augroup END
