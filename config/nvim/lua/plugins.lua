vim.cmd('packadd! packer.nvim')

return require('packer').startup(function()

	-- Neovim only plugins

	-- Package Manager
	use {'wbthomason/packer.nvim', opt = true}

	-- Tab Completion
	use {
		'nvim-lua/completion-nvim',
		requires = 'neovim/nvim-lspconfig',
		config = function()
			local completion = require('completion')
			local lsp = require('nvim_lsp')

			lsp.texlab.setup{settings = {latex = {build = {args = {'-lualatex'}}}}, on_attach = completion.on_attach()}
			lsp.clangd.setup{on_attach = completion.on_attach()}
			lsp.jedi_language_server.setup{on_attach = completion.on_attach()}

			completion.on_attach()

			-- Disable LSP diagnostics since ALE already provides diagnostics
			vim.lsp.callbacks['textDocument/publishDiagnostics'] = function() end
		end
	}

	-- Syntax Highlight, Semantic Text Objects
	use {
		'nvim-treesitter/nvim-treesitter',
		requires = 'nvim-treesitter/nvim-treesitter-textobjects',
		config = function()
			require'nvim-treesitter.configs'.setup{
				ensure_installed = {'c', 'cpp', 'python'},
				highlight = {enable = true},
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner"
						}
					},
					swap = {
						enable = true,
						swap_next = {
							["<C-l>"] = "@parameter.inner"
						},
						swap_previous = {
							["<C-h>"] = "@parameter.inner"
						}
					},
					move = {
						enable = true,
						goto_next_start = {
							["]m"] = "@function.outer"
						},
						goto_next_end = {
							["]M"] = "@function.outer"
						},
						goto_previous_start = {
							["[m"] = "@function.outer"
						},
						goto_previous_end = {
							["[M"] = "@function.outer"
						}
					},
					lsp_interop = {
						enable = true,
						peek_definition_code = {
							["gk"] = "@function.outer",
							["gK"] = "@class.outer"
						}
					}
				}
			}
		end
	}

	-- Git Signs
	use {
		'lewis6991/gitsigns.nvim',
		branch = 'main',
		requires = 'nvim-lua/plenary.nvim',
		config = function()
			require('gitsigns').setup{
				signs = {
					add          = {text = '+'},
					change       = {text = '~'},
					delete       = {text = '-'},
					topdelete    = {text = '^'},
					changedelete = {text = '_'}
				}
			}
		end
	}


	-- Linter and Snippets
	use 'khaveesh/ale'
	use 'khaveesh/vim-fish-syntax'
	use {'SirVer/ultisnips', event = 'InsertEnter *'}
	use {'honza/vim-snippets', event = 'InsertEnter *'}

	-- Markdown Distraction-Free Writing Mode
	use {'junegunn/goyo.vim', cmd = 'Goyo'}
	use {'junegunn/limelight.vim', cmd = 'Goyo'}

	-- Statusline
	use 'itchyny/lightline.vim'
	use 'maximbaz/lightline-ale'
	use 'mengelbrecht/lightline-bufferline'

	-- Colour Schemes
	use {'arcticicestudio/nord-vim', opt = true}
	use {'srcery-colors/srcery-vim', opt = true}

	-- Utilities
	use 'khaveesh/vim-unimpaired'
	use 'tpope/vim-commentary'
	use 'tpope/vim-repeat'
	use 'machakann/vim-sandwich'
	use 'wellle/targets.vim'
	use 'rhysd/clever-f.vim'
	use 'tmsvg/pear-tree'
	use 'AndrewRadev/sideways.vim'
	use 'tommcdo/vim-exchange'
	use {'junegunn/vim-easy-align', opt = true}
	use {'simnalamburt/vim-mundo', cmd = 'MundoToggle'}
	use 'romainl/vim-cool'
	use 'Konfekt/vim-CtrlXA'
	use {'sedm0784/vim-you-autocorrect', cmd = 'EnableAutocorrect'}

end)
