vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
	use {'wbthomason/packer.nvim', opt = true}

	-- Tab Completion, Syntax Highlight, Linter and Snippets
	use 'khaveesh/ale'
	use 'khaveesh/vim-fish-syntax'
	use {'neovim/nvim-lspconfig', event = 'InsertEnter *'}
	use {
		'nvim-lua/completion-nvim',
		event = 'InsertEnter *',
		config = function()
			local completion = require('completion')
			local lsp = require('nvim_lsp')
			lsp.texlab.setup{on_attach=completion.on_attach}
			lsp.clangd.setup{on_attach=completion.on_attach}
			lsp.jedi_language_server.setup{on_attach=completion.on_attach}
			completion.on_attach()
			vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
		end
	}
	use {'nvim-treesitter/nvim-treesitter', config = 'require"nvim-treesitter.configs".setup{highlight = {enable = true}}'}
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
	use {'tmsvg/pear-tree', event = 'InsertEnter *'}
	use 'AndrewRadev/sideways.vim'
	use 'tommcdo/vim-exchange'
	use {'junegunn/vim-easy-align', opt = true}
	use {'simnalamburt/vim-mundo', cmd = 'MundoToggle'}
	use {'npxbr/glow.nvim', cmd = 'Glow'}
	use 'romainl/vim-cool'
	use 'airblade/vim-gitgutter'
	use 'Konfekt/vim-CtrlXA'
	use {'sedm0784/vim-you-autocorrect', cmd = 'EnableAutocorrect'}

end)
