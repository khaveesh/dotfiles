"
"      ██╗  ██╗██╗  ██╗ █████╗ ██╗   ██╗███████╗███████╗███████╗██╗  ██╗
"      ██║ ██╔╝██║  ██║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝██║  ██║
"      █████╔╝ ███████║███████║██║   ██║█████╗  █████╗  ███████╗███████║
"      ██╔═██╗ ██╔══██║██╔══██║╚██╗ ██╔╝██╔══╝  ██╔══╝  ╚════██║██╔══██║
"      ██║  ██╗██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗███████║██║  ██║
"      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
"
"      One config to rule them all


" Autocmds

augroup custom
	autocmd!

	" Restore last file position
	autocmd BufReadPost *
				\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' && &diff == 0
				\ |   exe "normal! g`\""
				\ | endif

	" Format the file before saving
	autocmd BufWritePre * call functions#Format()

	" Highlight yanked region
	autocmd TextYankPost * silent lua vim.highlight.on_yank{higroup = 'IncSearch', timeout = 1000}

	" Update statusline on diagnostics change
	autocmd User LspDiagnosticsChanged call lightline#update() | lua vim.lsp.diagnostic.set_loclist({open_loclist = false})

	" Neovim only
	" Reset cursor shape on exit & restore on resume
	autocmd VimSuspend * let g:default_gc = &guicursor
	autocmd VimLeave,VimSuspend * set guicursor=n:ver25-blinkon100
	autocmd VimResume * let &guicursor = g:default_gc
augroup END


" Terminal Config

" 24-Bit Truecolor
set termguicolors
" Use POSIX-compliant shell instead of fish
set shell=sh

" EditorConfig

" Customize grep to use ripgrep
set grepprg=rg\ --vimgrep\ --smart-case
" Better grep command
command! -bar -nargs=1 Grep silent grep! <q-args> | cw
" Relative number for easy jumps
set relativenumber
" Disabled since integrated in Lightline
set noshowmode
" Suppress startup & completion messages
set shortmess+=Ic
" Set 3 lines to the cursor - when moving vertically using j/k
set scrolloff=3
" Make tab stops somewhat emulate spaces
set tabstop=4 shiftwidth=4
" Indicate that tab stops are used instead of spaces
set list
" Better search
set ignorecase smartcase
" Better substitute
set gdefault
" Prevents inserting two spaces after punctuation on a join
set nojoinspaces
" More natural split opening
set splitbelow splitright
" Quick switch buffer without worries
set hidden
" Completion
set pumheight=10
set completeopt=menuone,noselect,noinsert
" Wrap a long line into multiple lines with indent
set linebreak breakindent
let &showbreak = '↳ '

" Neovim only
" Live Preview of substitute
set inccommand=nosplit


" Editor Variables

" Markdown fenced languages syntax highlighting
let g:markdown_fenced_languages = ['python']
" Always use LaTeX flavour instead of plaintex
let g:tex_flavor = 'latex'
" Setting the python path reduces startup time
let g:python3_host_prog = '/usr/bin/python3'
" Disable unused providers
let g:loaded_python_provider = 0
let g:loaded_ruby_provider   = 0
let g:loaded_perl_provider   = 0
let g:loaded_node_provider   = 0

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_liststyle    = 3
let g:netrw_browse_split = 2
let g:netrw_winsize      = 25


" Keymappings

" Quick window switching
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" Repeat last macro used
nnoremap Q @@

" Toggle netrw
nnoremap <silent> <C-n> :Lexplore<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Source init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Split line at cursor
nnoremap gs i<CR><Esc>

" Some comment niceties on top of vim-commentary
nmap co ox<Esc>gcc0fx"_cl
nmap cO Ox<Esc>gcc0fx"_cl
nmap cA ox<Esc>gcc$kJfx"_cl

" Move through wrapped lines like normal ones, when count is not given
noremap <expr> j v:count == 0 ? 'gj' : 'j'
noremap <expr> k v:count == 0 ? 'gk' : 'k'

" Sensible n & N movement - Search centers on the line it's found in.
nnoremap <expr> n v:searchforward ? 'nzz' : 'Nzz'
nnoremap <expr> N v:searchforward ? 'Nzz' : 'nzz'

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
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Toggle Quickfix & Location Lists
nnoremap <silent> <expr> <leader>e empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <silent> <expr> <leader>l empty(filter(getwininfo(), 'v:val.loclist'))  ? ':lopen<CR>' : ':lclose<CR>'

" Markdown Preview using Pandoc
nnoremap <silent> <leader>m :silent exec "%w !fish -c 'panhtml -f " . &ft . "'"<CR>

" Use tab for completion navigation
inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" GitLens style blame
nnoremap gb :call functions#Blame()<CR>


" Plugin Configuration

" Colorscheme - Nord for low-contrast & Srcery for high-contrast
colorscheme nord

" Packer
command! PackerInstall lua require'plugins'.install()
command! PackerUpdate lua require'plugins'.update()
command! PackerSync lua require'plugins'.sync()
command! PackerClean lua require'plugins'.clean()
command! PackerCompile lua require'plugins'.compile()

" LSP Config - Server specific mappings
nnoremap <silent> <leader>h :ClangdSwitchSourceHeader<CR>
nnoremap <leader>b :w<CR>:TexlabBuild<CR>

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

" Pear Tree - Auto Pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1
" Restore <CR> for Completion confirmation
imap <nop> <Plug>(PearTreeExpand)

" Clever-F - Tweaks
let g:clever_f_mark_direct           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_fix_key_direction     = 1
let g:clever_f_chars_match_any_signs = '`'
let g:clever_f_across_no_line        = 1
nmap <Esc> <Plug>(clever-f-reset)

" Sideways - Shift and insert arguments
nnoremap <silent> [a :SidewaysLeft<CR>
nnoremap <silent> ]a :SidewaysRight<CR>
nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast

" Easy Align - Align by character
xmap ga <Plug>(EasyAlign)
nmap ga :packadd vim-easy-align<CR> <Plug>(EasyAlign)

" Mundo - Undo Tree Visualizer
nnoremap <silent> <F5> :MundoToggle<CR>

" Sandwich - Surround plugin
" Disable sandwich's textobj for the better targets version
let g:textobj_sandwich_no_default_key_mappings = 1
" Use vim-surround's keymaps
runtime macros/sandwich/keymap/surround.vim

" Ultisnips - Snippets
" Since <Tab> is already taken for Completion, use different trigger key
let g:UltiSnipsExpandTrigger = '<C-l>'

" Snippets - Reduce startup time
let g:snips_author = 'Khaveesh N'
let g:snips_email  = 'khaveesh@gmail.com'

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
