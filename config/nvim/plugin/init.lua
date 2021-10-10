-- FileType {{{

require('filetype').setup {
    overrides = {
        extensions = {
            md = 'markdown.pandoc',
        },
    },
}

--}}}

-- LSP {{{

local lsp = vim.lsp
local fmt = string.format

-- Statusline diagnostic info
function LspDiagnosticsSL()
    local e = lsp.diagnostic.get_count(0, 'Error')
    local w = lsp.diagnostic.get_count(0, 'Warning')

    local sl_error = (e ~= 0) and fmt('%%#ErrorMsg# E:%d ', e) or ''
    local sl_warning = (w ~= 0) and fmt('%%#Search# W:%d ', w) or ''
    return sl_error .. sl_warning
end

-- Custom LSP on_attach function
local function on_attach(client, bufnr)
    local function lsp_map(key, action, mode)
        mode = mode or 'n'
        local prefix = (mode == 'v') and ':' or '<cmd>'

        vim.api.nvim_buf_set_keymap(bufnr, mode, key, fmt('%slua vim.lsp.%s()<CR>', prefix, action), {
            noremap = true,
        })
    end

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

    if vim.bo.filetype ~= 'python' then
        lsp_map('[d', 'diagnostic.goto_prev')
        lsp_map(']d', 'diagnostic.goto_next')
        lsp_map('gl', 'diagnostic.set_loclist')
    end

    -- Indicate server provides formatter
    if client.resolved_capabilities.document_formatting then
        vim.bo.formatprg = 'lsp'
    end

    -- Add diagnostic info to statusline only for LSP clients
    vim.opt_local.statusline:append '%{%v:lua.LspDiagnosticsSL()%}'
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
local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp.protocol.make_client_capabilities())

-- Use a loop to conveniently setup multiple servers with custom config
for server, config in pairs(servers) do
    config.on_attach = on_attach
    config.capabilities = capabilities
    require('lspconfig')[server].setup(config)
end

-- Disable LSP signs
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
    signs = false,
})

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
        'regex',
        'toml',
        'yaml',
    },

    highlight = { enable = true },

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
                cmp.complete()
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
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },

    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        {
            name = 'buffer',
            opts = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end,
            },
        },
        { name = 'path' },
    },
}

-- }}}

-- Git Signs {{{

require('gitsigns').setup {
    signs = {
        add = { hl = 'DiffAdd', text = '+' },
        change = { hl = 'DiffChange', text = '~' },
        changedelete = { hl = 'DiffText' },
        delete = { hl = 'DiffDelete' },
        topdelete = { hl = 'DiffDelete' },
    },
}

-- }}}
