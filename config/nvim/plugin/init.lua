-- LSP {{{

local lsp = vim.lsp
local fmt = string.format

-- Statusline diagnostics
function LspDiagnosticsSL()
    local e = lsp.diagnostic.get_count(0, 'Error')
    local w = lsp.diagnostic.get_count(0, 'Warning')

    local sl_error = (e ~= 0) and fmt('%%#error# E:%d ', e) or ''
    local sl_warning = (w ~= 0) and fmt('%%#warning# W:%d ', w) or ''
    return sl_error .. sl_warning
end

-- Custom LSP on_attach function
local function on_attach(client, bufnr)
    local function lsp_map(key, action, mode)
        mode = mode or 'n'
        local prefix = (mode == 'v') and ':' or '<cmd>'

        vim.api.nvim_buf_set_keymap(
            bufnr,
            mode,
            key,
            fmt('%slua vim.lsp.%s()<CR>', prefix, action),
            { noremap = true }
        )
    end

    -- Override built-in keymaps only when client is attached
    lsp_map('<C-]>', 'buf.definition')
    lsp_map('<M-k>', 'buf.signature_help')
    lsp_map('<M-k>', 'buf.signature_help', 'i')
    lsp_map('<M-k>', 'buf.signature_help', 's')
    lsp_map('cq', 'buf.code_action')
    lsp_map('cq', 'buf.range_code_action', 'v')
    lsp_map('cr', 'buf.rename')
    lsp_map('dr', 'buf.references')
    lsp_map('gd', 'buf.declaration')
    lsp_map('gh', 'buf.hover')
    lsp_map('gs', 'buf.document_symbol')

    lsp_map('[d', 'diagnostic.goto_prev')
    lsp_map(']d', 'diagnostic.goto_next')
    lsp_map('gl', 'diagnostic.set_loclist')

    -- Set formatprg to the lsp client
    if client.resolved_capabilities.document_formatting then
        vim.bo.formatprg = 'lsp'
    end

    -- Add diagnostic info to statusline only for LSP clients
    vim.opt_local.statusline:append '%{%v:lua.LspDiagnosticsSL()%}'
end

-- Server config
local servers = {
    clangd = {},

    denols = { init_options = { lint = true, unstable = true } },

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

    vimls = {},
}

-- Indicate snippet support to server
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'additionalTextEdits',
        'detail',
        'documentation',
    },
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
for server, config in pairs(servers) do
    require('lspconfig')[server].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        unpack(config),
    }
end

-- Disable signs
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
})

-- }}}

-- Treesitter {{{

require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'c',
        'cpp',
        'fish',
        'json',
        'lua',
        'python',
        'toml',
        'yaml',
    },

    highlight = { enable = true, additional_vim_regex_highlighting = true },

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

-- Compe {{{

require('compe').setup {
    preselect = 'always',
    source = {
        buffer = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        omni = { filetypes = { 'fish' } },
    },
}

-- }}}

-- Git Signs {{{

require('gitsigns').setup {
    signs = {
        add = { hl = 'DiffAdd', text = '+' },
        change = { hl = 'DiffChange', text = '~' },
        changedelete = { hl = 'DiffText', text = '-' },
        delete = { hl = 'DiffDelete' },
        topdelete = { hl = 'DiffDelete' },
    },
}

-- }}}
