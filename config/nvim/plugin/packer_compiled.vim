" Automatically generated packer.nvim plugin loader code

if !has('nvim')
  finish
endif

lua << END
local plugins = {
  ["completion-nvim"] = {
    config = { "\27LJ\1\2\0\0\5\0\6\0\r4\0\0\0%\1\1\0>\0\2\0027\1\2\0%\2\3\0004\3\0\0%\4\3\0>\3\2\0027\3\4\3>\1\3\0017\1\5\0>\1\1\1G\0\1\0\14on_attach\18complete_item\tfish\24addCompletionSource\15completion\frequire\0" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/Users/khaveesh/.local/share/nvim/site/pack/packer/opt/completion-nvim"
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
loadstring('\27LJ\1\2Ñ\6\0\0\5\0"\0%4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\0013\2\6\0:\2\a\0013\2\v\0003\3\b\0003\4\t\0:\4\n\3:\3\f\0023\3\r\0003\4\14\0:\4\15\0033\4\16\0:\4\17\3:\3\18\0023\3\19\0003\4\20\0:\4\21\0033\4\22\0:\4\23\0033\4\24\0:\4\25\0033\4\26\0:\4\27\3:\3\28\0023\3\29\0003\4\30\0:\4\31\3:\3 \2:\2!\1>\0\2\1G\0\1\0\16textobjects\16lsp_interop\25peek_definition_code\1\0\2\agK\17@class.outer\agk\20@function.outer\1\0\1\venable\2\tmove\22goto_previous_end\1\0\1\a[M\20@function.outer\24goto_previous_start\1\0\1\a[m\20@function.outer\18goto_next_end\1\0\1\a]M\20@function.outer\20goto_next_start\1\0\1\a]m\20@function.outer\1\0\1\venable\2\tswap\18swap_previous\1\0\1\a[a\21@parameter.inner\14swap_next\1\0\1\a]a\21@parameter.inner\1\0\1\venable\2\vselect\1\0\0\fkeymaps\1\0\f\aic\17@class.inner\aai\23@conditional.outer\ail\16@loop.inner\aia\21@parameter.inner\aam\16@call.outer\aif\20@function.inner\aac\17@class.outer\aii\23@conditional.inner\aal\16@loop.outer\aaa\21@parameter.outer\aim\16@call.inner\aaf\20@function.outer\1\0\1\venable\2\14highlight\1\0\1\venable\2\21ensure_installed\1\0\0\1\4\0\0\6c\bcpp\vpython\nsetup\28nvim-treesitter.configs\frequire\0')()
-- Config for: gitsigns.nvim
loadstring("\27LJ\1\2µ\1\0\0\4\0\14\0\0174\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\f\0003\2\4\0003\3\3\0:\3\5\0023\3\6\0:\3\a\0023\3\b\0:\3\t\0023\3\n\0:\3\v\2:\2\r\1>\0\2\1G\0\1\0\nsigns\1\0\0\17changedelete\1\0\1\ttext\6_\vdelete\1\0\1\ttext\6-\vchange\1\0\1\ttext\6~\badd\1\0\0\1\0\1\ttext\6+\nsetup\rgitsigns\frequire\0")()
-- Config for: nvim-lspconfig
loadstring("\27LJ\1\2Ñ\t\0\1\a\0+\0v4\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\4\0%\5\5\0003\6\6\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\a\0%\5\b\0003\6\t\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\n\0%\5\v\0003\6\f\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\r\0%\5\14\0003\6\15\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\16\0%\5\17\0003\6\18\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\19\0%\5\20\0003\6\21\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\22\0%\5\23\0003\6\24\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\25\0%\5\26\0003\6\27\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\28\0%\5\29\0003\6\30\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\31\0%\5 \0003\6!\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4\"\0%\5#\0003\6$\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4%\0%\5&\0003\6'\0>\1\6\0014\1\0\0007\1\1\0017\1\2\1'\2\0\0%\3\3\0%\4(\0%\5)\0003\6*\0>\1\6\1G\0\1\0\1\0\1\fnoremap\0020<cmd>lua vim.lsp.diagnostic.goto_next()<CR>\a]d\1\0\1\fnoremap\0020<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>\a[d\1\0\1\fnoremap\2+<cmd>lua vim.lsp.buf.code_action()<CR>\acd\1\0\1\fnoremap\0020<cmd>lua vim.lsp.buf.workspace_symbol()<CR>\agW\1\0\1\fnoremap\2/<cmd>lua vim.lsp.buf.document_symbol()<CR>\ag0\1\0\1\fnoremap\2&<cmd>lua vim.lsp.buf.rename()<CR>\agR\1\0\1\fnoremap\2*<cmd>lua vim.lsp.buf.references()<CR>\agr\1\0\1\fnoremap\2/<cmd>lua vim.lsp.buf.type_definition()<CR>\b1gD\1\0\1\fnoremap\2.<cmd>lua vim.lsp.buf.implementation()<CR>\agD\1\0\1\fnoremap\2+<cmd>lua vim.lsp.buf.declaration()<CR>\agd\1\0\1\fnoremap\2*<cmd>lua vim.lsp.buf.definition()<CR>\n<C-]>\1\0\1\fnoremap\2.<cmd>lua vim.lsp.buf.signature_help()<CR>\n<C-k>\1\0\1\fnoremap\2%<cmd>lua vim.lsp.buf.hover()<CR>\6K\6n\24nvim_buf_set_keymap\bapi\bvimŠ\1\0\4\t\2\a\0\19\15\0\0\0T\4\5€4\4\0\0004\5\1\0\16\6\0\0>\5\2\0=\4\0\0014\4\2\0%\5\3\0004\6\4\0007\6\5\6+\a\0\0>\6\2\2%\a\6\0+\b\1\0006\b\2\b$\5\b\5>\4\2\1G\0\1\0\0À\0\0\6 \finspect\bvim\20Forward search \nprint\rtostring\nerror‹\2\1\0\a\1\16\1\0304\0\0\0007\0\1\0007\0\2\0'\1\0\0>\0\2\0023\1\6\0003\2\4\0004\3\0\0007\3\3\3'\4\0\0>\3\2\2:\3\5\2:\2\a\0013\2\b\0008\3\1\0\21\3\0\3:\3\t\0028\3\2\0:\3\n\2:\2\v\0014\2\0\0007\2\f\0027\2\r\2'\3\0\0%\4\14\0\16\5\1\0001\6\15\0>\2\5\0010\0\0€G\0\1\0\2À\0\31textDocument/forwardSearch\16buf_request\blsp\rposition\14character\tline\1\0\0\17textDocument\1\0\0\buri\1\0\0\19uri_from_bufnr\24nvim_win_get_cursor\bapi\bvim\2É\b\1\0\v\0@\0W4\0\0\0%\1\1\0>\0\2\0021\1\2\0004\2\3\0007\2\4\0023\3\5\0>\2\2\0023\3\6\0002\4\0\0:\4\a\0033\4#\0003\5!\0003\6\31\0003\a\t\0003\b\b\0:\b\n\a3\b\v\0:\b\f\a3\b\r\0:\b\14\a3\b\15\0:\b\16\a3\b\17\0:\b\18\a3\b\19\0:\b\20\a3\b\21\0:\b\22\a3\b\23\0:\b\24\a3\b\25\0:\b\26\a3\b\27\0:\b\28\a3\b\29\0:\b\30\a:\a \6:\6\"\5:\5$\4:\4\"\0033\4)\0003\5'\0003\6&\0001\a%\0;\a\1\6:\6(\5:\5*\0043\0053\0003\6.\0003\a,\0003\b+\0:\b-\a:\a/\0063\a0\0003\b1\0:\b-\a:\a2\6:\0064\5:\5$\4:\0045\0034\0046\0\16\5\3\0>\4\2\4D\a\5€:\0017\b6\t\a\0007\t8\t\16\n\b\0>\t\2\1B\a\3\3N\aù4\4\3\0007\0049\0047\4:\0044\5\3\0007\0059\0057\5<\0054\6\3\0007\0069\0067\6=\0067\6>\0063\a?\0>\5\3\2:\5;\0040\0\0€G\0\1\0\1\0\1\21update_in_insert\1\27on_publish_diagnostics\15diagnostic\twith$textDocument/publishDiagnostics\rhandlers\blsp\nsetup\14on_attach\npairs\vtexlab\nlatex\1\0\0\18forwardSearch\1\4\0\0\a%l\a%p\a%f\1\0\1\15executable>/Applications/Skim.app/Contents/SharedSupport/displayline\nbuild\1\0\0\targs\1\0\0\1\5\0\0\14-lualatex\29-interaction=nonstopmode\15-synctex=1\b-pv\rcommands\1\0\0\24TexlabForwardSearch\1\0\0\1\0\1\16description\31Run synctex forward search\0\rsettings\1\0\0\tpyls\1\0\0\fplugins\1\0\0\tyapf\1\0\1\fenabled\1\trope\1\0\1\fenabled\1\rpyflakes\1\0\1\fenabled\1\16pycodestyle\1\0\1\fenabled\1\vmccabe\1\0\1\fenabled\1\rautopep8\1\0\1\fenabled\1\nblack\1\0\1\fenabled\2\nisort\1\0\1\fenabled\2\14pyls_mypy\1\0\1\fenabled\2\vpylint\1\0\1\fenabled\2\vflake8\1\0\0\1\0\1\fenabled\2\vclangd\1\0\0\1\0\4\fFailure\3\2\17Unconfigured\3\3\nError\3\1\fSuccess\3\0\27tbl_add_reverse_lookup\bvim\0\14lspconfig\frequire\0")()
-- Conditional loads
-- Load plugins in order defined by `after`
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads
command! -nargs=* -range -bang -complete=file MundoToggle call s:load(['vim-mundo'], { "cmd": "MundoToggle", "l1": <line1>, "l2": <line2>, "bang": <q-bang>, "args": <q-args> })

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
  au InsertEnter * ++once call s:load(['ultisnips', 'vim-snippets', 'completion-nvim'], { "event": "InsertEnter *" })
augroup END
