-- vim: foldmethod=marker

-- LSP {{{

-- Custom on_attach function
local function on_attach(client, bufnr)
  local function lsp_map(key, action, mode)
    vim.keymap.set(mode or 'n', key, vim.lsp.buf[action], { buffer = bufnr })
  end

  local function diagnostic_map(key, action)
    vim.keymap.set('n', key, vim.diagnostic[action], { buffer = bufnr })
  end

  lsp_map('<C-]>', 'definition')
  lsp_map('<M-k>', 'signature_help', { 'n', 'i', 's' })
  lsp_map('cq', 'code_action')
  lsp_map('cq', 'range_code_action', 'v')
  lsp_map('cr', 'rename')
  lsp_map('dr', 'references')
  lsp_map('gd', 'declaration')
  lsp_map('gh', 'hover')
  lsp_map('gs', 'document_symbol')

  -- Diagnostics
  if vim.bo.filetype ~= 'python' then
    diagnostic_map('[d', 'goto_prev')
    diagnostic_map(']d', 'goto_next')
    diagnostic_map('gl', 'setloclist')
    vim.b.lsp_sl = ''
    vim.cmd [[ autocmd! DiagnosticChanged <buffer> lua require('diagnostics_sl')() ]]
    vim.wo.statusline = vim.o.statusline .. '%{%b:lsp_sl%}'
  end

  -- Indicate server provides formatter
  if client.resolved_capabilities.document_formatting then
    vim.b.formatprg = 'lsp'
  end
end

-- Server config
local servers = {
  clangd = {},

  jedi_language_server = {},

  texlab = {
    settings = {
      texlab = {
        build = {
          args = {
            '-lualatex',
            '-interaction=nonstopmode',
            '-synctex=1',
            '-pv',
            '%f',
          },
        },
        forwardSearch = {
          executable = 'displayline',
          args = { '%l', '%p', '%f' },
        },
      },
    },
  },
}

-- Indicate snippet support to server
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use a loop to setup multiple servers with custom config
for server, config in pairs(servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  require('lspconfig')[server].setup(config)
end

-- }}}

-- Treesitter {{{

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'fish',
    'json',
    'latex',
    'lua',
    'python',
    'toml',
    'vim',
    'yaml',
  },

  highlight = { enable = true },

  matchup = { enable = true },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ai'] = '@conditional.outer',
        ['ii'] = '@conditional.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner',
      },
    },

    swap = {
      enable = true,
      swap_previous = {
        ['[a'] = '@parameter.inner',
      },
      swap_next = {
        [']a'] = '@parameter.inner',
      },
    },

    move = {
      enable = true,
      goto_previous_start = {
        ['[m'] = '@function.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
      },
      goto_next_start = {
        [']m'] = '@function.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
      },
    },

    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['dc'] = '@class.outer',
        ['dm'] = '@function.outer',
      },
    },
  },
}

-- }}}

-- nvim-cmp {{{

local cmp = require 'cmp'

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available']() == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.mapping.complete()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, {
      'i',
      's',
    }),

    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm(),
  },

  sources = cmp.config.sources {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = vim.api.nvim_list_bufs,
      },
    },
    { name = 'path' },
  },
}

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  },
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- }}}
