"
"      ██╗  ██╗██╗  ██╗ █████╗ ██╗   ██╗███████╗███████╗███████╗██╗  ██╗
"      ██║ ██╔╝██║  ██║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝██║  ██║
"      █████╔╝ ███████║███████║██║   ██║█████╗  █████╗  ███████╗███████║
"      ██╔═██╗ ██╔══██║██╔══██║╚██╗ ██╔╝██╔══╝  ██╔══╝  ╚════██║██╔══██║
"      ██║  ██╗██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗███████║██║  ██║
"      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
"

" Plugins {{{

let g:packages = []

" Custom Pack command to interface with external `python` plugin manager
" via JSON dump call made through a headless nvim process
command -buffer -nargs=+ Pack call s:packadd(<args>)

function s:packadd(pack, args = {}) abort
    if empty(a:args)
        " Default type is 'start'
        call add(g:packages, [a:pack, { 'type': 'start' }])
    else
        call add(g:packages, [a:pack, a:args])
    endif
endfunction

" Lua Plugins {{{

" Sensible Defaults
Pack 'khaveesh/nvim-sensibly-opinionated-defaults'

" LSP - Language Services & Completion
Pack 'neovim/nvim-lspconfig'
Pack 'hrsh7th/nvim-cmp'
Pack 'hrsh7th/cmp-nvim-lsp'
Pack 'hrsh7th/cmp-vsnip'
Pack 'hrsh7th/cmp-buffer'
Pack 'hrsh7th/cmp-path'

" Semantic highlighting & text-objects
Pack 'nvim-treesitter/nvim-treesitter'
Pack 'nvim-treesitter/nvim-treesitter-textobjects'

" Git Gutter
Pack 'nvim-lua/plenary.nvim'
Pack 'lewis6991/gitsigns.nvim'

" Faster ftdetect
Pack 'nathom/filetype.nvim'
let g:did_load_filetypes = 1

" }}}

" Essentials {{{

" Syntax files
Pack 'khaveesh/vim-fish-syntax'
Pack 'vim-pandoc/vim-pandoc-syntax'

" Color Scheme
Pack 'gruvbox-community/gruvbox', { 'type': 'opt' }
set termguicolors
set background=light
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic           = 1
let g:gruvbox_contrast_light   = 'hard'
colorscheme gruvbox
highlight! default link LspSignatureActiveParameter WarningMsg

" VSCode/LSP snippets
Pack 'hrsh7th/vim-vsnip'
let g:vsnip_snippet_dir = stdpath('config').'/vsnip'

" }}}

" Utilities {{{

" Handy square bracket mappings
Pack 'khaveesh/vim-unimpaired'

" Comment & uncomment lines
Pack 'khaveesh/vim-commentary-yank'

" Manipulate surrounding delimiters
Pack 'tpope/vim-surround'

" Dot-repeat support for plugins
Pack 'tpope/vim-repeat'

" Text exchange operator
Pack 'tommcdo/vim-exchange'

" }}}

" }}}

" EditorConfig {{{

set shell=dash                        " Use POSIX-compliant shell
set gdefault                          " Better substitute
set expandtab tabstop=4 shiftwidth=4  " Expand tab stops to be 4 spaces
set spelloptions=camel                " Spell check camelCased components

" Completion popup
set pumheight=15

" NerdTree style netrw
let g:netrw_banner    = 0
let g:netrw_liststyle = 3
let g:netrw_winsize   = 25

" Disable unused providers to reduce startup time
let g:loaded_node_provider    = 0
let g:loaded_perl_provider    = 0
let g:loaded_python_provider  = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider    = 0

" }}}

" Commands {{{

" Format before save
autocmd! BufWritePre * call functions#Format()

" Look up documentation, mapped to K
set keywordprg=:DD
command -nargs=+ DD call system(functions#DevDocs(<q-args>))

" Better grep command (romain-l)
command -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:Grep(<f-args>) | cw

function s:Grep(...) abort
    return system(join(['rg --vimgrep --smart-case'] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

cnoreabbrev <expr> grep
            \ (getcmdtype() == ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" }}}

" Keymaps {{{

" Toggle netrw
nnoremap <silent> yd :Lexplore<CR>

" Toggle spell check
nnoremap zy :syntax match SingleChar '\<\A*\a\A*\>' contains=@NoSpell<CR>:
            \ setlocal <C-r>=&spell ? 'nospell' : 'spell'<CR><CR>

" Jetpack mapping - Fast switch, split or unload buffers
nnoremap gb :ls<CR>:b
nnoremap gB :ls<CR>:vert sb

" Call macro recorded in register q
nnoremap Q @q
" Edit recorded macro
nnoremap cm :let @<C-r>=v:register.'='.string(getreg(v:register))<CR><C-f><left>

" Format and update
nnoremap gw :up<CR>
" Indent and update
nnoremap <silent> gW mwgg=G`w:delmark w <bar> up<CR>

" Quick exit
nnoremap <silent> gq :q<CR>
nnoremap          gQ :qa<CR>

" View register contents
nnoremap gr    :registers<CR>
noremap! <M-r> <cmd>registers<CR>

" Quick copy/cut into system clipboard
nnoremap cy "+y
nnoremap cd "+d
xnoremap cy "+y
xnoremap cd "+d

" Map unused large size normal mode keys to useful functions
map <Tab>   %
map <S-Tab> g%
nnoremap <BS>    <C-^>
nnoremap <Space> <C-w>

" Echo file info
nnoremap <leader>f :echo "\t" &ft &fenc &ff<CR>

" Edit init.vim
nnoremap <silent> <leader>v :edit ~/.config/nvim/init.vim<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Buffer delete
nnoremap <silent> <leader>q :bd<CR>
nnoremap <silent> <leader>Q :bd!<CR>

" Toggle Quickfix & Location lists
nnoremap <silent><expr> <leader>l
            \ empty(filter(getwininfo(), 'v:val.loclist'))
            \ ? ':lwindow<CR>' : ':lclose<CR>'
nnoremap <silent><expr> <leader>c
            \ empty(filter(getwininfo(), 'v:val.quickfix'))
            \ ? ':cwindow<CR>' : ':cclose<CR>'

" Terminal
nnoremap <silent> <M-z> :call functions#ToggleTerminal()<CR>
tnoremap <silent> <M-z> <C-\><C-n>:call functions#ToggleTerminal()<CR>

" Change/Delete surrounding function
nnoremap csf F(cb
nmap     dsf dsbdb

" Some niceties on top of vim-commentary
nnoremap co ox<Esc>:Commentary<CR>W"_s
nnoremap cO Ox<Esc>:Commentary<CR>W"_s
nnoremap cA ox<Esc>:Commentary<CR>k$J2W"_s

" }}}

" Statusline {{{

" File info
let &statusline = '%#StatusLineNC# %m %f %h%w  '
" Multiple buffers indicator
let &statusline .= '%{ &bl && '
            \ . "len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1"
            \ . " ? '[Buffers Listed]' : '' }"

set statusline+=%=

" Git Status
let &statusline .= "%{ exists('b:gitsigns_status')"
            \             . " ? ' ' . b:gitsigns_status : '' }"
" Position info
let &statusline .= ' %#StatusLine# %l,%c │ %P '

" }}}
