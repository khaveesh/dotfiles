-- LSP {{{

local lsp = vim.lsp

-- Statusline functions
function LspErrorsSL()
    local e = lsp.diagnostic.get_count(0, [[Error]])
    return (e ~= 0) and (' E:' .. e .. ' ') or ''
end

function LspWarningsSL()
    local w = lsp.diagnostic.get_count(0, [[Warning]])
    return (w ~= 0) and (' W:' .. w .. ' ') or ''
end

-- Custom LSP on_attach
local function on_attach(client, bufnr)
    local function lsp_map(key, action, mode)
        local prefix = ':'
        if mode == 'i' then
            prefix = '<cmd>'
        end
        mode = mode or 'n'

        vim.api.nvim_buf_set_keymap(bufnr, mode, key, prefix .. 'lua vim.lsp.' .. action .. '()<CR>', {
            noremap = true,
            silent = true,
        })
    end

    -- Override built-in keymaps only when client is attached
    lsp_map('<C-k>', 'buf.signature_help', 'i')
    lsp_map('<C-k>', 'buf.signature_help')
    lsp_map('<C-]>', 'buf.definition')
    lsp_map('<M-k>', 'buf.hover')
    lsp_map('ga', 'buf.range_code_action', 'v')
    lsp_map('ga', 'buf.code_action')
    lsp_map('gd', 'buf.declaration')
    lsp_map('dr', 'buf.references')
    lsp_map('cr', 'buf.rename')
    lsp_map('gs', 'buf.document_symbol')
    lsp_map('[d', 'diagnostic.goto_prev')
    lsp_map(']d', 'diagnostic.goto_next')

    -- Set formatprg to the lsp client
    if client.resolved_capabilities.document_formatting then
        vim.bo.formatprg = 'lsp'
    end

    -- Add diagnostic info to statusline only for LSP clients
    vim.wo.statusline = vim.o.statusline
        .. '%#error#%{v:lua.LspErrorsSL()}'
        .. '%#warning#%{v:lua.LspWarningsSL()}'
end

-- Server config
local servers = {
    clangd = {},

    denols = { init_options = { lint = true, unstable = true } },

    jedi_language_server = {},

    texlab = {
        settings = {
            latex = {
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

-- Express snippet support to server
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    },
}

-- Setup client
local nvim_lsp = require('lspconfig')
for server, config in pairs(servers) do
    config.on_attach = on_attach
    config.capabilities = capabilities
    nvim_lsp[server].setup(config)
end

-- Delay diagnostics while in insert mode & don't show signs
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = false,
    signs = false,
})

-- }}}

-- Treesitter {{{

require('nvim-treesitter.configs').setup({
    ensure_installed = { 'c', 'cpp', 'python', 'lua' },
    highlight = { enable = true },

    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ['am'] = '@call.outer',
                ['im'] = '@call.inner',
                ['ai'] = '@conditional.outer',
                ['ii'] = '@conditional.inner',
                ['al'] = '@loop.outer',
                ['il'] = '@loop.inner',
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['as'] = '@statement.outer',
            },
        },

        swap = {
            enable = true,
            swap_next = {
                [']a'] = '@parameter.inner',
            },
            swap_previous = {
                ['[a'] = '@parameter.inner',
            },
        },

        move = {
            enable = true,
            goto_next_start = {
                [']m'] = '@function.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
            },
        },

        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ['dm'] = '@function.outer',
                ['dc'] = '@class.outer',
            },
        },
    },
})

-- }}}

-- Compe {{{

require('compe').setup({
    preselect = 'always',
    source = {
        buffer = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        omni = { filetypes = { 'fish' } },
    },
})

-- }}}

-- Git Signs {{{

require('gitsigns').setup({
    signs = {
        add = { hl = 'DiffAdd', text = '+' },
        change = { hl = 'DiffChange', text = '~' },
        changedelete = { hl = 'DiffText', text = '-' },
        delete = { hl = 'DiffDelete' },
        topdelete = { hl = 'DiffDelete' },
    },
})

-- }}}
