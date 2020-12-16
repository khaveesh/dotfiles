"
"      ██╗  ██╗██╗  ██╗ █████╗ ██╗   ██╗███████╗███████╗███████╗██╗  ██╗
"      ██║ ██╔╝██║  ██║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝██║  ██║
"      █████╔╝ ███████║███████║██║   ██║█████╗  █████╗  ███████╗███████║
"      ██╔═██╗ ██╔══██║██╔══██║╚██╗ ██╔╝██╔══╝  ██╔══╝  ╚════██║██╔══██║
"      ██║  ██╗██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗███████║██║  ██║
"      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
"
"      One config to rule them all


" Autocmds {{{

augroup custom
	autocmd!

	" Completion
	autocmd BufEnter * lua require'completion'.on_attach()
	autocmd InsertEnter * ++once packadd vim-snippets | packadd ultisnips

	" Format the file before saving (Neovim only)
	autocmd BufWritePre * call functions#Format()

	" Update statusline on diagnostics change (Neovim only)
	autocmd User LspDiagnosticsChanged call lightline#update() | lua vim.lsp.diagnostic.set_loclist({open_loclist = false})

	" Reset cursor shape on exit & restore on resume (Neovim only)
	autocmd VimSuspend * let g:default_gc = &guicursor
	autocmd VimLeave,VimSuspend * set guicursor=n:ver25-blinkon100
	autocmd VimResume * let &guicursor = g:default_gc
augroup END

" }}}


" EditorConfig {{{

set shell=sh                             " Use POSIX-compliant shell instead of fish
set grepprg=rg\ --vimgrep\ --smart-case  " Customize grep to use ripgrep
set noshowmode                           " Disabled since it is integrated in Lightline
set tabstop=4 shiftwidth=4               " Make tab stops somewhat emulate spaces
set gdefault                             " Better substitute
set nojoinspaces                         " Don't insert two spaces after punctuation on join

" Completion
set pumheight=12
set completeopt=menuone,noinsert,noselect

" Better grep command
command! -bar -nargs=1 Grep silent grep! <q-args> | cw

" }}}


" Editor Variables {{{

" Setting the python path reduces startup time
let g:python3_host_prog = '/usr/bin/python3'
" Disable unused providers
let g:loaded_python_provider = 0
let g:loaded_ruby_provider   = 0
let g:loaded_perl_provider   = 0
let g:loaded_node_provider   = 0

" Markdown fenced languages syntax highlighting
let g:markdown_fenced_languages = ['python']

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_liststyle    = 3
let g:netrw_browse_split = 2
let g:netrw_winsize      = 25

" }}}


" Keymappings {{{

" Move through wrapped lines like normal ones, when count is not given
noremap <expr> j v:count == 0 ? 'gj' : 'j'
noremap <expr> k v:count == 0 ? 'gk' : 'k'

" Sensible n & N movement - Search centers on the line it's found in.
nnoremap <expr> n v:searchforward ? 'nzz' : 'Nzz'
nnoremap <expr> N v:searchforward ? 'Nzz' : 'nzz'

" Use tab for completion navigation
inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" Repeat last macro used
nnoremap Q @@

" Some comment niceties on top of vim-commentary
nmap co ox<Esc>gcc0fx"_cl
nmap cO Ox<Esc>gcc0fx"_cl
nmap cA ox<Esc>gcc$kJfx"_cl

" Split line at cursor
nnoremap gs i<CR><Esc>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/

" Quick window switching
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" w wq q qq  --  Quick Save & Exit
nnoremap <leader>w  :w<CR>
nnoremap <leader>ww :normal! gg=G<C-o><CR>:w<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>qa :qa<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq ZQ
nnoremap <silent> <C-q> :bd<CR>

" y d p P  --  Quick copy paste into system clipboard
nnoremap <leader>y "+y
nnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>d "+d

" Toggle Quickfix & Location Lists
nnoremap <silent> <expr> <leader>e empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <silent> <expr> <leader>l empty(filter(getwininfo(), 'v:val.loclist'))  ? ':lopen<CR>' : ':lclose<CR>'

" Preview document using Pandoc
nnoremap <silent> <leader>p :silent exec "%w !fish -c 'panhtml -f " . &ft . "'"<CR>

" GitLens style blame
nnoremap gb :call functions#Blame()<CR>

" Source init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Toggle netrw
nnoremap <silent> <C-n> :Lexplore<CR>

" }}}


" Plugins {{{

" Packager - Plugin Manager
function! s:packager_init(packager) abort
	call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})

	" Neovim only plugins {{
	" Defaults
	call a:packager.add('khaveesh/nvim-sensibly-opinionated-defaults')

	" Tab Completion - LSP & other sources
	call a:packager.add('nvim-lua/completion-nvim', {'requires': 'neovim/nvim-lspconfig'})

	" Syntax Highlight & Semantic Text Objects
	call a:packager.add(
				\ 'nvim-treesitter/nvim-treesitter',
				\ {
				\	'do':       ':TSUpdate',
				\	'requires': 'nvim-treesitter/nvim-treesitter-textobjects'
				\ })

	" Git Gutter
	call a:packager.add('lewis6991/gitsigns.nvim', {'requires': 'nvim-lua/plenary.nvim'})
	" }}

	" Colour Schemes
	call a:packager.add('khaveesh/nord-vim')                          " Low Contrast
	call a:packager.add('srcery-colors/srcery-vim', {'type': 'opt'})  " High Contrast

	" Linter and Snippets
	call a:packager.add('khaveesh/vim-fish-syntax')
	call a:packager.add('SirVer/ultisnips', {'type': 'opt'})
	call a:packager.add('honza/vim-snippets', {'type': 'opt'})

	" Statusline
	call a:packager.add('itchyny/lightline.vim')
	call a:packager.add('mengelbrecht/lightline-bufferline')

	" Utilities
	call a:packager.add('khaveesh/vim-unimpaired')
	call a:packager.add('khaveesh/pear-tree')
	call a:packager.add('machakann/vim-sandwich')
	call a:packager.add('wellle/targets.vim')
	call a:packager.add('CherryMan/vim-commentary-yank')
	call a:packager.add('AndrewRadev/sideways.vim')
	call a:packager.add('rhysd/clever-f.vim')
	call a:packager.add('tommcdo/vim-exchange')
	call a:packager.add('tpope/vim-repeat')
	call a:packager.add('romainl/vim-cool')
	call a:packager.add('simnalamburt/vim-mundo', {'type': 'opt'})
	call a:packager.add('junegunn/vim-easy-align', {'type': 'opt'})
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'), {'dir': stdpath('data') . '/site/pack/packager'})

" }}}


" Plugin Configuration {{{

" Colorscheme
let g:nord_underline       = 1
let g:nord_italic_comments = 1
colorscheme nord

" Initializes settings for Lua plugins
lua require'init'

" LSP Config - Server specific mappings
nnoremap <silent> <leader>b :w<CR>:TexlabBuild<CR>
nnoremap <silent> <leader>h :ClangdSwitchSourceHeader<CR>

" Completion
let g:completion_chain_complete_list = {
			\ 'fish': [
			\	{'complete_items': ['fish', 'snippet']},
			\	{'mode': '<c-p>'},
			\	{'mode': '<c-n>'},
			\	{'complete_items': ['path']}
			\ ],
			\ 'default': {
			\	'default': [
			\		{'complete_items': ['lsp', 'snippet']},
			\		{'mode': '<c-p>'},
			\		{'mode': '<c-n>'}
			\	 ],
			\	'string': [{'complete_items': ['path']}]
			\ }
			\ }
let g:completion_enable_auto_hover   = 0
let g:completion_auto_change_source  = 1
let g:completion_enable_auto_paren   = 1
let g:completion_enable_snippet      = 'UltiSnips'
let g:completion_confirm_key         = "\<CR>"
let g:completion_abbr_length         = 60

" Pear Tree - Auto pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1
" Restore <CR> for Completion confirmation
imap <nop> <Plug>(PearTreeExpand)

" Sideways - Shift and insert arguments
nnoremap <silent> [a :SidewaysLeft<CR>
nnoremap <silent> ]a :SidewaysRight<CR>
nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast

" Clever-F - Tweaks
let g:clever_f_mark_direct           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_fix_key_direction     = 1
let g:clever_f_chars_match_any_signs = '`'
let g:clever_f_across_no_line        = 1
nmap <Esc> <Plug>(clever-f-reset)

" Lightline - Statusline
let g:lightline = {
			\	'active': {
			\		'left': [
			\			['mode'],
			\			['readonly', 'filename', 'modified'],
			\			['gitstatus']
			\		],
			\		'right': [
			\			['lsp_warnings', 'lsp_errors'],
			\			['percent', 'lineinfo'],
			\			['filetype']
			\		]
			\	},
			\	'tabline': {'left': [['buffers']], 'right': []},
			\	'component_function': {
			\		'gitstatus': 'functions#LightlineGitGutter'
			\	},
			\	'component_function_visible_condition': {'gitstatus': 1},
			\	'component_expand': {
			\		'lsp_warnings': 'functions#LspWarnings',
			\		'lsp_errors':   'functions#LspErrors',
			\		'buffers':      'lightline#bufferline#buffers'
			\	},
			\	'component_type': {
			\		'lsp_warnings': 'warning',
			\		'lsp_errors':   'error',
			\		'buffers':      'tabsel'
			\	},
			\	'colorscheme': 'nord'
			\ }

" Lightline - Bufferline
let g:lightline#bufferline#show_number      = 2
let g:lightline#bufferline#min_buffer_count = 2

" Bufferline - Buffer switching mappings
nmap <leader>1 <Plug>lightline#bufferline#go(1)
nmap <leader>2 <Plug>lightline#bufferline#go(2)
nmap <leader>3 <Plug>lightline#bufferline#go(3)
nmap <leader>4 <Plug>lightline#bufferline#go(4)
nmap <leader>5 <Plug>lightline#bufferline#go(5)
nmap <leader>6 <Plug>lightline#bufferline#go(6)
nmap <leader>7 <Plug>lightline#bufferline#go(7)
nmap <leader>8 <Plug>lightline#bufferline#go(8)
nmap <leader>9 <Plug>lightline#bufferline#go(9)

nmap <leader>c1 <Plug>lightline#bufferline#delete(1)
nmap <leader>c2 <Plug>lightline#bufferline#delete(2)
nmap <leader>c3 <Plug>lightline#bufferline#delete(3)
nmap <leader>c4 <Plug>lightline#bufferline#delete(4)
nmap <leader>c5 <Plug>lightline#bufferline#delete(5)
nmap <leader>c6 <Plug>lightline#bufferline#delete(6)
nmap <leader>c7 <Plug>lightline#bufferline#delete(7)
nmap <leader>c8 <Plug>lightline#bufferline#delete(8)
nmap <leader>c9 <Plug>lightline#bufferline#delete(9)

" Easy Align - Align by character
xmap ga <Plug>(EasyAlign)
nmap ga :packadd vim-easy-align<CR> <Plug>(EasyAlign)

" Mundo - Undo Tree Visualizer
nnoremap <silent> <F5> :packadd vim-mundo<CR>:MundoToggle<CR>

" Sandwich - Surround plugin
" Use target's textobjs instead of sandwich
let g:textobj_sandwich_no_default_key_mappings = 1
" Use vim-surround's keymaps
runtime macros/sandwich/keymap/surround.vim

" Ultisnips - Snippets
" Since <Tab> is already taken for Completion, use different trigger key
let g:UltiSnipsExpandTrigger = '<C-l>'

" Snippets - Reduce startup time
let g:snips_author = 'Khaveesh N'
let g:snips_email  = 'khaveesh@gmail.com'

" }}}
