-- LSP Config
local custom_lsp_attach = function(client)
    -- Override built-in keymaps only when LSP client is attached
    vim.api.nvim_buf_set_keymap(0, 'n',  'gK'  , '<cmd>lua vim.lsp.buf.hover()<CR>'           , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>'  , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>'      , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'gd'  , '<cmd>lua vim.lsp.buf.declaration()<CR>'     , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'gD'  , '<cmd>lua vim.lsp.buf.implementation()<CR>'  , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  '1gD' , '<cmd>lua vim.lsp.buf.type_definition()<CR>' , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'gr'  , '<cmd>lua vim.lsp.buf.references()<CR>'      , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'gR'  , '<cmd>lua vim.lsp.buf.rename()<CR>'          , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'g0'  , '<cmd>lua vim.lsp.buf.document_symbol()<CR>' , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  'cd'  , '<cmd>lua vim.lsp.buf.code_action()<CR>'     , { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  '[d'  , '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n',  ']d'  , '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true })

    if client.config.flags then
        client.config.flags.allow_incremental_sync = true
    end
end

local texlab_search_status = vim.tbl_add_reverse_lookup{
    Success      = 0;
    Error        = 1;
    Failure      = 2;
    Unconfigured = 3;
}

local servers = {
    clangd = {},

    pyls = {
        settings = {
            pyls = {
                plugins = {
                    flake8    = { enabled = true },
                    pylint    = { enabled = true },
                    pyls_mypy = { enabled = true },
                    isort     = { enabled = true },
                    black     = { enabled = true },

                    autopep8    = { enabled = false },
                    mccabe      = { enabled = false },
                    pycodestyle = { enabled = false },
                    pyflakes    = { enabled = false },
                    rope        = { enabled = false },
                    yapf        = { enabled = false }
                }
            }
        }
    },

    texlab = {
        commands = {
            TexlabForwardSearch = {
                function()
                    local pos = vim.api.nvim_win_get_cursor(0)
                    local params = {
                        textDocument = { uri = vim.uri_from_bufnr(0) },
                        position = { line = pos[1] - 1, character = pos[2] }
                    }

                    vim.lsp.buf_request(0, 'textDocument/forwardSearch', params,
                        function(err, _, result, _)
                            if err then error(tostring(err)) end
                            print('Forward search ' .. vim.inspect(pos) .. ' ' .. texlab_search_status[result])
                        end)
                end;
                description = 'Run synctex forward search'
            }
        },
        settings = {
            latex = {
                build = {
                    args = {'-lualatex', '-interaction=nonstopmode', '-synctex=1', '-pv', '%f'}
                },
                forwardSearch = {
                    executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
                    args = {'%l', '%p', '%f'}
                }
            }
        }
    }
}

for server, config in pairs(servers) do
    require'lspconfig'[server].setup{config, on_attach = custom_lsp_attach}
end

-- Delay LSP diagnostics while in insert mode
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    { update_in_insert = false }
)


-- Treesitter
require'nvim-treesitter.configs'.setup{
    ensure_installed = {'c', 'cpp', 'python'},
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
                ['ia'] = '@parameter.inner'
            }
        },

        swap = {
            enable = true,
            swap_next = {
                [']a'] = '@parameter.inner'
            },
            swap_previous = {
                ['[a'] = '@parameter.inner'
            }
        },

        move = {
            enable = true,
            goto_next_start = {
                [']m'] = '@function.outer'
            },
            goto_next_end = {
                [']M'] = '@function.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.outer'
            },
            goto_previous_end = {
                ['[M'] = '@function.outer'
            }
        },

        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ['gk']  = '@function.outer',
                ['1gk'] = '@class.outer'
            }
        }
    }
}


-- Git Signs
require('gitsigns').setup{
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '-' },
        changedelete = { text = '_' }
    }
}
