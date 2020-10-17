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

	" Better commenting
	autocmd BufEnter * setlocal formatoptions-=ro

	" Toggle between appropriate number formats
	autocmd BufEnter,WinEnter * setlocal nonu rnu
	autocmd BufLeave,WinLeave * setlocal nu nornu

	" Restore last file position
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exec "normal! g`\"zz" | endif

	" Highlight yanked region
	autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup = 'IncSearch', timeout = 1000}

	" Extend cycle list
	autocmd VimEnter * let b:CtrlXA_Toggles = [
				\ ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'],
				\ ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
				\ ['january', 'february', 'march', 'april', 'may', 'june',
				\	'july', 'august', 'september', 'october', 'november', 'december'],
				\ ['January', 'February', 'March', 'April', 'May', 'June',
				\	'July', 'August', 'September', 'October', 'November', 'December'],
				\ ] + g:CtrlXA_Toggles

	" Set *.h files as c-headers instead of C++
	autocmd BufEnter *.h setlocal filetype=c

	" Workaround netrw bug when hidden is set
	autocmd FileType netrw setlocal bufhidden=wipe

	" Limelight - Goyo integration
	autocmd! User GoyoEnter Limelight
	autocmd! User GoyoLeave Limelight!

	" Reset cursor shape on exit
	autocmd VimLeave,VimSuspend * set guicursor=a:ver25-blinkon100
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
set shortmess+=Ic
" Set 3 lines to the cursor - when moving vertically using j/k
set scrolloff=3
" Live Preview of substitute
set inccommand=nosplit
" Make tab stops somewhat emulate spaces
set tabstop=4 shiftwidth=4
" Turn off the obnoxious ^I tab character
set list
" Better search
set ignorecase smartcase
" Better substitute
set gdefault
" Shorter timeout length
set timeoutlen=625
" Prevents inserting two spaces after punctuation on a join
set nojoinspaces
" More natural split opening
set splitbelow splitright
" Prevent screen redraw for non typed text
set lazyredraw
" Quick switch buffer without worries
set hidden
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

" More intuitive Y
nnoremap Y y$

" Repeat last macro used
nnoremap Q @@

" Toggle netrw
nnoremap <silent> <c-n> :Lexplore<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/\<<c-r><c-w>\>/<c-r><c-w>

" Source init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Split line at cursor
nnoremap gs i<CR><esc>

" Some comment niceties on top of vim-commentary
nmap     gco ox<esc>gcc0fx"_cl
nmap     gcO Ox<esc>gcc0fx"_cl
nmap     gcA ox<esc>gcc$kJfx"_cl
nnoremap gcy :<c-u>exec 'normal '.v:count.'yy'.v:count.'gcc'<CR>

" Move through wrapped lines like normal ones
noremap <expr> j v:count == 0 ? 'gj' : 'j'
noremap <expr> k v:count == 0 ? 'gk' : 'k'

" Sensible n & N movement - Search centers on the line it's found in.
nnoremap <expr> n v:searchforward ? 'nzz' : 'Nzz'
nnoremap <expr> N v:searchforward ? 'Nzz' : 'nzz'

" w wq q qq  --  Quick Save & Exit
nnoremap <leader>w  :w<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>wq ZZ
nnoremap <leader>qq ZQ
nnoremap <silent> <c-q> :bd<CR>

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


" Plugin Configuration

" Colorscheme - Nord for low-contrast & Srcery for high-contrast
let g:nord_underline       = 1
let g:nord_italic_comments = 1
colorscheme nord

" Packer
command! PackerInstall lua require('plugins').install()
command! PackerUpdate lua require('plugins').update()
command! PackerSync lua require('plugins').sync()
command! PackerClean lua require('plugins').clean()
command! PackerCompile lua require('plugins').compile()

" LSP Config - Key Mappings
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gR    <cmd>lua vim.lsp.buf.rename()<CR>

" Completion
set pumheight=10
set completeopt=menuone,noinsert,noselect
" Use tab for completion navigation
inoremap <expr> <tab>   pumvisible() ? '<c-n>' : '<tab>'
inoremap <expr> <s-tab> pumvisible() ? '<c-p>' : '<s-tab>'
let g:completion_chain_complete_list  = [
			\ {'complete_items': ['lsp', 'snippet']},
			\ {'mode': '<c-p>'},
			\ {'mode': '<c-n>'},
			\ {'complete_items': ['path']},
			\ ]
let g:completion_enable_auto_hover    = 0
let g:completion_auto_change_source   = 1
let g:completion_matching_ignore_case = 1
let g:completion_enable_snippet       = 'UltiSnips'
let g:completion_confirm_key          = ''

" ALE - Asynchronous Lint (also format) Engine
let g:ale_fix_on_save  = 1
let g:ale_disable_lsp  = 1
let g:ale_sign_warning = '!'
let g:ale_sign_error   = '✖'
nmap <M-j> <Plug>(ale_next_wrap)
nmap <M-k> <Plug>(ale_previous_wrap)

" ALE - Linters
let g:ale_linters#python        = ['flake8', 'pylint', 'mypy']
let g:ale_python_mypy_options   = '--ignore-missing-imports'
let g:ale_c_cc_options          = '-Weverything -Wno-padded -std=c17'
let g:ale_cpp_cc_options        = '-Weverything -Wno-padded -std=c++17'
let g:ale_c_cppcheck_options    = '--enable=all --suppress=unusedFunction'
let g:ale_cpp_cppcheck_options  = g:ale_c_cppcheck_options
let g:ale_c_clangtidy_options   = '-isystem /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/'
let g:ale_cpp_clangtidy_options = '-isystem /Library/Developer/CommandLineTools/usr/include/c++/v1/'
let g:ale_vale_options          = '--config=/Users/khaveesh/.config/vale/vale.ini'
let g:ale_tex_chktex_options    = '-wall -n 21 -n 22 -n 30'
let g:ale_c_clangtidy_checks    = ['*', '-cppcoreguidelines-init-variables', '-readability-isolate-declaration', '-android-cloexec-fopen',
			\ '-readability-braces-around-statements', '-hicpp-braces-around-statements', '-google-readability-braces-around-statements',
			\ '-readability-magic-numbers', '-cppcoreguidelines-avoid-magic-numbers', '-llvmlibc-restrict-system-libc-headers',
			\ '-misc-no-recursion']
let g:ale_cpp_clangtidy_checks  = g:ale_c_clangtidy_checks
let g:ale_python_mypy_ignore_invalid_syntax = 1

" ALE - Fixers (Formatters)
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

" Pear Tree - Auto Pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1

" Clever-F - Tweaks
let g:clever_f_mark_direct           = 1
let g:clever_f_smart_case            = 1
let g:clever_f_fix_key_direction     = 1
let g:clever_f_chars_match_any_signs = '`'
let g:clever_f_across_no_line        = 1
nmap <esc> <Plug>(clever-f-reset)

" Sideways - Shift and insert arguments
nnoremap <c-h>  :SidewaysLeft<CR>
nnoremap <c-l>  :SidewaysRight<CR>
nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast

" Easy Align - Set mappings
xmap ga <Plug>(EasyAlign)
nmap ga :packadd vim-easy-align<CR> <Plug>(EasyAlign)

" Autocorrect - Set mappings
nmap <leader>u <Plug>VimyouautocorrectUndo
imap <F3> <c-o><Plug>VimyouautocorrectUndo
nnoremap <leader>sp :setlocal spelllang=en_gb<CR> :EnableAutocorrect<CR>

" Mundo - Undo Tree Visualizer
nnoremap <silent> <F5> :MundoToggle<CR>

" Goyo - Minimalist Markdown writing mode
nnoremap <silent> <leader>gy :Goyo<CR>

" Glow - Markdown Preview in Terminal
nnoremap <silent> <leader>mp :Glow<CR>

" Sandwich - Disable sandwich's textobj for the better targets version
let g:textobj_sandwich_no_default_key_mappings = 1

" Ultisnips - Snippets
let g:UltiSnipsExpandTrigger = '<c-l>' " Since <tab> is already taken for Completion

" Targets - Seek only to lines visible on current screen
let g:targets_seekRanges = 'cc cr cb lc ac lr ab rr rb'

" Snippets - Reduce startup time
let g:snips_author = 'Khaveesh N'
let g:snips_email  = 'khaveesh@gmail.com'

" Lightline - Statusline
let g:gitgutter_grep = 'rg'

function! LightlineGitGutter() abort
	let [l:a, l:m, l:r] = GitGutterGetHunkSummary()
	if l:a == 0 && l:m == 0 && l:r == 0
		return ' N/A'
	endif
	return printf(' +%d ~%d -%d', l:a, l:m, l:r)
endfunction

function! LightlineReadonly() abort
	return &readonly ? '' : ''
endfunction

let g:lightline = {
			\	'active' : {
			\		'left': [
			\			['mode', 'paste'],
			\			['readonly', 'filename', 'modified'],
			\			['gitstatus']
			\		],
			\		'right': [
			\			['linter_errors', 'linter_warnings', 'linter_infos'],
			\			['percent', 'lineinfo'],
			\			['filetype']
			\		]
			\	},
			\	'tabline': {'left': [['buffers']], 'right': []},
			\	'component_function': {
			\		'gitstatus': 'LightlineGitGutter',
			\		'readonly':  'LightlineReadonly'
			\	},
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
			\	'colorscheme': 'nord',
			\	'separator': {'left': '', 'right': ''},
			\	'subseparator': {'left': '', 'right': ''}
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
