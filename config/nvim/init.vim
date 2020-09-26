" Autocmds

augroup every_buffer
	autocmd!

	" Better commenting
	autocmd BufEnter * setlocal formatoptions-=ro
	" Set *.h files as C-headers instead of C++
	autocmd BufEnter *.h setlocal filetype=c
	" Set spell check and language
	autocmd FileType markdown packadd vim-you-autocorrect | exec 'EnableAutocorrect' | setlocal spell spelllang=en_gb

	" Toggle between appropriate number formats
	autocmd BufEnter,WinEnter * setlocal rnu
	autocmd BufLeave,WinLeave * setlocal nu nornu
	" Needs neovim nightly to highlight yanked region
	" autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
	" Reset cursor shape on exit
	autocmd VimLeave,VimSuspend * set guicursor=a:ver100-blinkon100

	" Limelight - Goyo integration
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!
augroup END


" EditorConfig

" 24-Bit Truecolor
set termguicolors
" Full mouse support
set mouse=a
" Customize shell and grep to use preferred tools
set shell=/usr/local/bin/fish
set grepprg=rg\ --vimgrep
" Disabled since integrated in Lightline
set noshowmode
" Suppress startup message
set shortmess+=I
" Set 3 lines to the cursor - when moving vertically using j/k
set scrolloff=3
" Live Preview of substitute
set inccommand=nosplit
" Make tab stops somewhat emulate spaces
set tabstop=4
set shiftwidth=4
" Turn off the obnoxious ^I tab character
set list
" Better search
set ignorecase
set smartcase
" Better substitute
set gdefault
" Shorter timeout length
set timeoutlen=625
" Prevents inserting two spaces after punctuation on a join
set nojoinspaces
" More natural split opening
set splitbelow
set splitright
" Prevent screen redraw for non typed text
set lazyredraw
" Wrap a long line into multiple lines
set breakindent
set linebreak
let &showbreak = '↳ '
" Markdown Fenced Syntax highlighting
let g:markdown_fenced_languages = ['python']
" Always use LaTeX flavour instead of plaintex
let g:tex_flavor = 'latex'
" Setting the python path reduces startup time
let g:python3_host_prog = '/usr/bin/python3'

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_liststyle    = 3
let g:netrw_browse_split = 4
let g:netrw_altv         = 1
let g:netrw_winsize      = 25


" Keymappings

" Toggle netrw
nnoremap <silent> <C-n> :Lexplore<CR>

" Repeat last macro used
nnoremap Q @@

" Substitute the word under the cursor.
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Source init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" More intuitive Y
nnoremap Y y$

" Split line at cursor
nnoremap gs i<CR><ESC>

" Some comment niceties
nmap     gco ox<ESC>gcc0fxcl
nmap     gcO Ox<ESC>gcc0fxcl
nmap     gcA ox<ESC>gcc$kJfxcl
nnoremap gcy :<C-u>exec 'normal '.v:count.'yy'.v:count.'gcc'<CR>

" Sensible n & N movement - Search centers on the line it's found in.
nnoremap <expr>   n  (v:searchforward ? 'nzz' : 'Nzz')
nnoremap <expr>   N  (v:searchforward ? 'Nzz' : 'nzz')
nnoremap <silent> *  *zz
nnoremap <silent> #  #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" Move through wrapped lines like normal
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" w wq q qq  --  Quick Save & Exit
nnoremap <leader>w  :w<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq :q!<CR>

" y d p P  --  Quick copy paste into system clipboard
nnoremap <leader>y "+y
nnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Quick close buffer
nnoremap <silent> <C-q> :bd<CR>

" Frequent Misspellings
cnoreabbrev Q! q!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev W  w
cnoreabbrev Q  q
cnoreabbrev Qa qa


" Plugins

function! PackInit() abort
	packadd minpac
	call minpac#init({'dir': stdpath('data') . '/site'})
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	" Tab Completion, Syntax Highlight, Linter and Snippets
	call minpac#add('khaveesh/ale')
	call minpac#add('khaveesh/vim-fish-syntax')
	call minpac#add('maralla/completor.vim')
	call minpac#add('Shougo/echodoc.vim')
	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')

	" Markdown Distraction-Free Writing Mode
	call minpac#add('junegunn/goyo.vim', {'type': 'opt'})
	call minpac#add('junegunn/limelight.vim', {'type': 'opt'})

	" Statusline
	call minpac#add('itchyny/lightline.vim')
	call minpac#add('mengelbrecht/lightline-bufferline', {'type': 'opt'})
	call minpac#add('maximbaz/lightline-ale', {'type': 'opt'})

	" Colour Scheme
	call minpac#add('srcery-colors/srcery-vim', {'type': 'opt'})
	call minpac#add('luochen1990/rainbow')

	" Utilities
	call minpac#add('tpope/vim-commentary')
	call minpac#add('tpope/vim-unimpaired')
	call minpac#add('tpope/vim-repeat')
	call minpac#add('machakann/vim-sandwich')
	call minpac#add('machakann/vim-highlightedyank')
	call minpac#add('wellle/targets.vim')
	call minpac#add('simnalamburt/vim-mundo', {'type': 'opt'})
	call minpac#add('rhysd/clever-f.vim')
	call minpac#add('tmsvg/pear-tree')
	call minpac#add('AndrewRadev/sideways.vim')
	call minpac#add('airblade/vim-gitgutter')
	call minpac#add('junegunn/vim-easy-align', {'type': 'opt'})
	call minpac#add('romainl/vim-cool')
	call minpac#add('sedm0784/vim-you-autocorrect', {'type': 'opt'})
	call minpac#add('nishigori/increment-activator')
	call minpac#add('Valloric/ListToggle')
	call minpac#add('npxbr/glow.nvim', {'type': 'opt'})

	" Niceties
	call minpac#add('psliwka/vim-smoothie')
	call minpac#add('farmergreg/vim-lastplace')
endfunction

command! PackSync call PackInit() | call minpac#update() | call minpac#clean()


" Plugin Configuration

" Colorscheme
let g:srcery_italic = 1
colorscheme srcery

" ALE
let g:ale_fix_on_save  = 1
let g:ale_disable_lsp  = 1
let g:ale_sign_warning = '!'
let g:ale_sign_error   = '✖'
nmap <silent> <A-j> <Plug>(ale_next_wrap)
nmap <silent> <A-k> <Plug>(ale_previous_wrap)

" ALE Linters
let g:ale_linters#python        = ['flake8', 'pylint', 'mypy']
let g:ale_python_mypy_options   = '--ignore-missing-imports'
let g:ale_c_cc_options          = '-Weverything -Wno-padded -std=c17'
let g:ale_cpp_cc_options        = '-Weverything -Wno-padded -std=c++17'
let g:ale_c_cppcheck_options    = '--enable=all --suppress=unusedFunction'
let g:ale_cpp_cppcheck_options  = g:ale_c_cppcheck_options
let g:ale_c_clangtidy_options   = '-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/'
let g:ale_cpp_clangtidy_options = '-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1/'
let g:ale_vale_options          = '--config=/Users/khaveesh/.config/vale/vale.ini'
let g:ale_tex_chktex_options    = '-wall -n 22 -n 30'
let g:ale_c_clangtidy_checks    = ['*', '-cppcoreguidelines-init-variables', '-readability-isolate-declaration', '-android-cloexec-fopen', '-readability-braces-around-statements', '-hicpp-braces-around-statements', '-google-readability-braces-around-statements', '-readability-magic-numbers', '-cppcoreguidelines-avoid-magic-numbers', '-llvm-include-order']
let g:ale_cpp_clangtidy_checks  = g:ale_c_clangtidy_checks
let g:ale_python_mypy_ignore_invalid_syntax = 1

" ALE Fixers (Formatters)
let g:ale_fixers = {
			\ '*':        ['remove_trailing_lines', 'trim_whitespace'],
			\ 'python':   ['isort', 'black'],
			\ 'c':        ['clang-format'],
			\ 'cpp':      ['clang-format'],
			\ 'markdown': ['pandoc'],
			\ 'tex':      ['latexindent'],
			\ 'fish':     ['fish_indent']
			\ }
let g:ale_python_black_options         = '-l 100'
let g:ale_python_isort_options         = '--profile black'
let g:ale_markdown_pandoc_target_flags = ['-inline_code_attributes', '-fenced_code_attributes']
let g:ale_markdown_pandoc_options      = ['--atx-headers', '--columns=80']
let g:ale_tex_latexindent_options      = '-c=/tmp/'
let g:ale_c_clangformat_options        = '-style="{BasedOnStyle: LLVM, IndentWidth: 4, BreakBeforeBraces: Linux, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, SortIncludes: false}"'

" Completor
let g:completor_filetype_map = {'tex': {'ft':'lsp', 'cmd':'texlab'}}
" Use TAB for completion navigation
inoremap <expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
" Mappings for completor actions
nnoremap <silent> gd :call completor#do('definition')<CR>
nnoremap <silent> gr :call completor#do('doc')<CR>
nnoremap <silent> K  :call completor#do('hover')<CR>

" Pear Tree - Auto Pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1

" Echodoc for function argument preview
" Use neovim's floating text feature.
let g:echodoc#enable_at_startup = 1
let g:echodoc#type              = 'floating'
" Custom highlight for the float window,
highlight link EchoDocFloat Pmenu

" Clever-F
let g:clever_f_mark_direct           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_fix_key_direction     = 1
let g:clever_f_chars_match_any_signs = '`'
let g:clever_f_across_no_line        = 1
nmap <ESC> <Plug>(clever-f-reset)

" Increment cycle
let g:increment_activator_filetype_candidates = {
			\	'_' : [
			\		['left', 'right', 'centre'],
			\		['show', 'hide'],
			\		['top', 'bottom', 'middle'],
			\		['before', 'after'],
			\		['first', 'last'],
			\		['+', '-'],
			\		['>', '<'],
			\		['"', "'"],
			\		['==', '!='],
			\		['-=', '+='],
			\		['&&', '||'],
			\		['0', '1'],
			\		['and', 'or'],
			\		['in', 'out'],
			\		['up', 'down'],
			\		['min', 'max'],
			\		['get', 'set'],
			\		['add', 'remove'],
			\		['to', 'from'],
			\		['read', 'write'],
			\		['only', 'except'],
			\		['without', 'with'],
			\		['exclude', 'include'],
			\		['even', 'odd'],
			\		['inside', 'outside'],
			\		['push', 'pull'],
			\	],
			\ }

" Sideways - Shift and insert arguments
nnoremap <C-h> :SidewaysLeft<CR>
nnoremap <C-l> :SidewaysRight<CR>
nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast

" Easy Align
" Start interactive EasyAlign in visual mode
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object
nmap ga :packadd vim-easy-align<CR> <Plug>(EasyAlign)

" Vim Autocorrect for markdown
nmap <leader>u <Plug>VimyouautocorrectUndo
imap <F3>      <C-O><Plug>VimyouautocorrectUndo

" Mundo - Undo Tree Visualizer
nnoremap <silent> <F5> :packadd vim-mundo<CR> :MundoToggle<CR>

" Goyo - Minimalist Markdown writing mode
nnoremap <silent> <leader>gy :packadd goyo.vim<CR> :packadd limelight.vim<CR> :Goyo<CR>

" Glow - Markdown Preview in Terminal
nnoremap <silent> <leader>mp :packadd glow.nvim<CR> :Glow<CR>

" Disable sandwich's textobj for the better targets version
let g:textobj_sandwich_no_default_key_mappings = 1

" ListToggle
let g:lt_quickfix_list_toggle_map = '<leader>e' " Since q is already taken for quit

" Ultisnips - Snippets
let g:UltiSnipsExpandTrigger = '<C-l>' " Since <TAB> is already taken for Completion

" Rainbow Parentheses
let g:rainbow_active = 1

" Lightline - Statusline
function! LightlineGitGutter() abort
	let [l:a, l:m, l:r] = GitGutterGetHunkSummary()
	if l:a == 0 && l:m == 0 && l:r == 0
		return 'Git - NA'
	endif
	return printf('+%d ~%d -%d', l:a, l:m, l:r)
endfunction

let g:gitgutter_grep = 'rg'
packadd! srcery-vim
packadd! lightline-bufferline
packadd! lightline-ale
let g:lightline = {
			\	'colorscheme': 'srcery',
			\	'component_expand' : {
			\		'linter_infos':    'lightline#ale#infos',
			\		'linter_warnings': 'lightline#ale#warnings',
			\		'linter_errors':   'lightline#ale#errors',
			\		'buffers':         'lightline#bufferline#buffers'
			\	},
			\	'component_type' : {
			\		'linter_infos':    'right',
			\		'linter_warnings': 'warning',
			\		'linter_errors':   'error',
			\		'buffers':         'tabsel'
			\	},
			\	'active' : {
			\		'left': [
			\			['mode', 'paste'],
			\			['gitstatus', 'readonly', 'filename', 'modified']
			\		],
			\		'right': [
			\			['linter_errors', 'linter_warnings', 'linter_infos'],
			\			['lineinfo'],
			\			['percent'],
			\			['fileformat', 'fileencoding', 'filetype']
			\		]
			\	},
			\	'tabline': {
			\		'left':  [['buffers']],
			\		'right': []
			\	},
			\	'component_function': {
			\		'gitstatus': 'LightlineGitGutter'
			\	}
			\ }

" Lightline - Bufferline
let g:lightline#bufferline#show_number      = 2
let g:lightline#bufferline#min_buffer_count = 2

" Buffer switching mappings
nmap <leader>1 <Plug>lightline#bufferline#go(1)
nmap <leader>2 <Plug>lightline#bufferline#go(2)
nmap <leader>3 <Plug>lightline#bufferline#go(3)
nmap <leader>4 <Plug>lightline#bufferline#go(4)
nmap <leader>5 <Plug>lightline#bufferline#go(5)
nmap <leader>6 <Plug>lightline#bufferline#go(6)
nmap <leader>7 <Plug>lightline#bufferline#go(7)
nmap <leader>8 <Plug>lightline#bufferline#go(8)
nmap <leader>9 <Plug>lightline#bufferline#go(9)
nmap <leader>0 <Plug>lightline#bufferline#go(10)

nmap <leader>c1 <Plug>lightline#bufferline#delete(1)
nmap <leader>c2 <Plug>lightline#bufferline#delete(2)
nmap <leader>c3 <Plug>lightline#bufferline#delete(3)
nmap <leader>c4 <Plug>lightline#bufferline#delete(4)
nmap <leader>c5 <Plug>lightline#bufferline#delete(5)
nmap <leader>c6 <Plug>lightline#bufferline#delete(6)
nmap <leader>c7 <Plug>lightline#bufferline#delete(7)
nmap <leader>c8 <Plug>lightline#bufferline#delete(8)
nmap <leader>c9 <Plug>lightline#bufferline#delete(9)
nmap <leader>c0 <Plug>lightline#bufferline#delete(10)
