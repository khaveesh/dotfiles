-- LSP {{{

-- Override built-in keymaps only when client is attached
local function on_attach(client, bufnr)
    local function lsp_map(key, action, mode)
        mode = mode or 'n'
        vim.api.nvim_buf_set_keymap(
            bufnr,
            mode,
            key,
            '<cmd>lua vim.lsp.' .. action .. '()<CR>',
            { noremap = true }
        )
    end

    lsp_map('<C-k>', 'buf.signature_help', 'i')
    lsp_map('<C-k>', 'buf.signature_help')
    lsp_map('<C-]>', 'buf.definition')
    lsp_map('gA', 'buf.code_action')
    lsp_map('gd', 'buf.declaration')
    lsp_map('gK', 'buf.hover')
    lsp_map('gr', 'buf.references')
    lsp_map('gR', 'buf.rename')
    lsp_map('gs', 'buf.document_symbol')
    lsp_map('[d', 'diagnostic.goto_prev')
    lsp_map(']d', 'diagnostic.goto_next')

    if client.resolved_capabilities.document_formatting then
        vim.bo.formatprg = 'lsp'
    end
end

-- Server config
local servers = {
    clangd = {},

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
}

local lsp = vim.lsp

-- Express snippet support to server
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Setup client
local nvim_lsp = require('lspconfig')
for server, config in pairs(servers) do
    config.on_attach = on_attach
    config.capabilities = capabilities
    nvim_lsp[server].setup(config)
end

-- Delay diagnostics while in insert mode
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(
    lsp.diagnostic.on_publish_diagnostics,
    { update_in_insert = false, signs = false }
)

-- }}}

-- Treesitter {{{

require('nvim-treesitter.configs').setup({
    ensure_installed = { 'c', 'cpp', 'python', 'lua' },
    highlight = { enable = true },
    indent = { enable = true },

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

-- Compe & VSnip integration {{{

require('compe').setup({
    preselect = 'always',
    source = {
        buffer = true,
        nvim_lsp = true,
        nvim_lua = true,
        path = true,
        vsnip = { priority = 10000 },
        omni = { filetypes = { 'fish' } },
        treesitter = { filetypes = { 'lua' } },
    },
})

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
function tab_complete()
    local function check_back_space()
        local col = vim.fn.col('.') - 1
        return (col == 0 or vim.fn.getline('.'):sub(col, col):match('%s'))
    end

    if vim.fn.pumvisible() == 1 then
        return t('<C-n>')
    elseif vim.fn.call('vsnip#available', { 1 }) == 1 then
        return t('<Plug>(vsnip-expand-or-jump)')
    elseif check_back_space() then
        return t('<Tab>')
    else
        return vim.fn['compe#complete']()
    end
end

function s_tab_complete()
    if vim.fn.pumvisible() == 1 then
        return t('<C-p>')
    elseif vim.fn.call('vsnip#jumpable', { -1 }) == 1 then
        return t('<Plug>(vsnip-jump-prev)')
    else
        return t('<S-Tab>')
    end
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- }}}

-- Git Signs {{{

require('gitsigns').setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        changedelete = { text = '_' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
    },
})

-- }}}
