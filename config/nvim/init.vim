"
"      ██╗  ██╗██╗  ██╗ █████╗ ██╗   ██╗███████╗███████╗███████╗██╗  ██╗
"      ██║ ██╔╝██║  ██║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝██║  ██║
"      █████╔╝ ███████║███████║██║   ██║█████╗  █████╗  ███████╗███████║
"      ██╔═██╗ ██╔══██║██╔══██║╚██╗ ██╔╝██╔══╝  ██╔══╝  ╚════██║██╔══██║
"      ██║  ██╗██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗███████║██║  ██║
"      ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
"

" Autocmds {{{

" Highlights for the statusline
function s:Highlight() abort
    " Gruvbox Light colors
    hi statusline guibg=#665c54 guifg=#ebdbb2
    hi info       guibg=#d5c4a1 guifg=#282828
    hi warning    guibg=#b57614 guifg=#fbf1c7
    hi error      guibg=#fbf1c7 guifg=#9d0006

    hi! link TabLineSel BufTabLineCurrent
endfunction

augroup custom
    autocmd!

    " Prevent the highlights from being cleared on reload
    autocmd ColorScheme * call s:Highlight()

    " Format the file before saving (Neovim only)
    autocmd BufWritePre * call functions#Format()
augroup END

" }}}

" EditorConfig {{{

set termguicolors                              " Enable 24-Bit Truecolor
set shell=dash                                 " Use POSIX-compliant shell
set completeopt=menuone,noselect pumheight=15  " Completion popup
set gdefault                                   " Better substitute
set expandtab tabstop=4 shiftwidth=4           " Expand tabstops to be 4 spaces
set diffopt+=foldcolumn:0                      " Disable extra column for folds
set grepprg=rg\ --vimgrep\ --smart-case        " Customize grep to use ripgrep
set keywordprg=:DD                             " Search Dash.app for keywords

" Use spacebar as leader
let mapleader = "\<Space>"
nnoremap <Space> <nop>

" Colorscheme
set background=light
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic           = 1
let g:gruvbox_contrast_light   = 'hard'
colorscheme gruvbox

" Setting the python path reduces startup time
let g:python3_host_prog = '/usr/bin/python3'
" Disable unused providers
let g:loaded_node_provider   = 0
let g:loaded_perl_provider   = 0
let g:loaded_python_provider = 0
let g:loaded_ruby_provider   = 0

" Markdown fenced languages syntax highlighting
let g:markdown_fenced_languages = ['python']

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_browse_split = 2
let g:netrw_liststyle    = 3
let g:netrw_winsize      = 25

" }}}

" Statusline {{{

" Statusline Functions
function LspErrors() abort
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let e = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
        return e != 'null' ? ' E:' . e . ' ' : ''
    endif
    return ''
endfunction

function LspWarnings() abort
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
        let w = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
        return w != 'null' ? "\ua0W:" . w . ' ' : ''
    endif
    return ''
endfunction

function GitStatus() abort
    return exists('b:gitsigns_status') ? ' ' . b:gitsigns_status : ''
endfunction

function Buffers() abort
    return len(getbufinfo({ 'buflisted': 1 })) > 1 && &bl ? '[Buffers Listed]' : ''
endfunction

" Left section
set statusline=%#statusline#\ %m\ %f\ %h%w\ \ \ %{Buffers()}%=
" Right section
set statusline+=%{GitStatus()}\ \ %#info#\ \ %l\:%c\ \|\ %P
" LSP section
set statusline+=\ %#error#%{LspErrors()}%#warning#%{LspWarnings()}

" }}}

" Keymappings {{{

" Map unused normal mode keys to useful functions
nnoremap <CR> :
vnoremap <CR> :
nnoremap <BS> <C-^>
nnoremap \ <C-w>
map <Tab> %
map <S-Tab> g%

" Call macro
nnoremap Q @q

" Jetpack mapping - Fast switch, split or unload buffers
nmap gb :ls<CR>
nnoremap gB :ls<CR>:vert sb

" Edit recorded macros
nnoremap cm :<C-u><C-r><C-r>='let @'.v:register.' = '.string(getreg(v:register))<CR><C-f><left>

" Clear search highlighting
noremap <silent> <C-l> <cmd>nohls<CR><C-l>

" Toggle netrw
nnoremap <silent> yd :Lexplore<CR>

" Toggle Quickfix & Location Lists
nnoremap <silent><expr> <leader>q
            \ empty(filter(getwininfo(), 'v:val.quickfix')) ? ':cwindow<CR>' : ':cclose<CR>'
nnoremap <silent><expr> <leader>l
            \ empty(filter(getwininfo(), 'v:val.loclist'))  ? ':lwindow<CR>' : ':lclose<CR>'

" Echo current file's info
nnoremap <leader>f :echo "\t" &ft &fenc &ff<CR>

" Reload init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Quick copy/delete into system clipboard
nnoremap cy "+y
nnoremap cd "+d
vnoremap cy "+y
vnoremap cd "+d

" Quick save & exit
nnoremap <leader>w :up<CR>
nnoremap <leader>W mwgg=G`w:up<CR>
nnoremap <silent> <C-q> :bd<CR>
nnoremap <silent> <M-q> :bd!<CR>

" Use CCR to provide intuitive auto prompt
cnoremap <expr> <CR> functions#CCR()
nnoremap gm :g//#<left><left>
nmap <leader>m :marks<CR>
nmap <leader>j :jumps<CR>
nmap <leader>Q :clist<CR>
nmap <leader>L :llist<CR>
nmap <leader>o :browse oldfiles<CR>

" Some niceties on top of vim-commentary
nmap co ox<Esc>gcc0fx"_cl
nmap cO Ox<Esc>gcc0fx"_cl
nmap cA ox<Esc>gcc$kJfx"_cl

" Change/Delete surrounding function
nnoremap csf F(cb
nmap dsf dsbdb

" }}}

" Commands {{{

" Lazy load package manager
command! -bar VPO packadd vim-packager
            \     | call packager#setup(function('s:packager_init'),
            \          {'dir': stdpath('data') . '/site/pack/packager'})
command! -bar VP VPO | PackagerClean | PackagerUpdate

" Better grep command (romain-l)
function s:Grep(...) abort
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:Grep(<f-args>) | cwindow
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" Look up documentation in Dash.app
command! -nargs=+ DD silent exe '!'.functions#DevDocs(<q-args>)

" }}}

" Plugins {{{

" Packager - Plugin Manager
function s:packager_init(packager) abort
    " Manage packager as optional plugin
    call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})

    " Neovim only plugins {{{

    " Defaults
    call a:packager.add('khaveesh/nvim-sensibly-opinionated-defaults')

    " Tab Completion - LSP & other sources
    call a:packager.add('hrsh7th/nvim-compe',
                \         {'requires': 'neovim/nvim-lspconfig'})

    " Syntax highlight & Semantic textobjs
    call a:packager.add('nvim-treesitter/nvim-treesitter', {
                \     'do':       ':TSUpdate',
                \     'requires': 'nvim-treesitter/nvim-treesitter-textobjects'
                \ })

    " Git Gutter
    call a:packager.add('lewis6991/gitsigns.nvim',
                \         {'requires': 'nvim-lua/plenary.nvim'})

    " }}}

    " Snippets & Syntax files
    call a:packager.add('hrsh7th/vim-vsnip')
    call a:packager.add('khaveesh/vim-fish-syntax')

    " Colour Schemes
    call a:packager.add('gruvbox-community/gruvbox', {'type': 'opt'})
    call a:packager.add('tanvirtin/nvim-monokai', {'type': 'opt'})

    " Utilities
    call a:packager.add('khaveesh/vim-commentary-yank')
    call a:packager.add('khaveesh/vim-unimpaired')
    call a:packager.add('tpope/vim-surround')
    call a:packager.add('tpope/vim-repeat')
    call a:packager.add('tmsvg/pear-tree')
    call a:packager.add('AndrewRadev/sideways.vim')
    call a:packager.add('tommcdo/vim-exchange')
    call a:packager.add('junegunn/vim-easy-align', {'type': 'opt'})
    call a:packager.add('simnalamburt/vim-mundo', {'type': 'opt'})
endfunction

" }}}

" Plugin Configuration {{{

" Initializes configuration for Lua plugins (Neovim only)
lua require('init')

" Nvim-Compe
inoremap <expr> <CR>  compe#confirm({ 'keys': "\<Plug>(PearTreeExpand)", 'mode': 'i' })
inoremap <expr> <C-e> compe#close('<C-e>')
inoremap <expr> <C-f> compe#scroll({ 'delta': +4 })
inoremap <expr> <C-d> compe#scroll({ 'delta': -4 })

" vim-vsnip - LSP & VSCode snippets
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'

" Pear Tree - Auto pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1
" Restore <CR> for completion confirmation
imap <nop> <Plug>(PearTreeExpand)

" Sideways - Shift and insert arguments
nnoremap <silent> [a :SidewaysLeft<CR>
nnoremap <silent> ]a :SidewaysRight<CR>

nmap <leader>i <Plug>SidewaysArgumentInsertBefore
nmap <leader>a <Plug>SidewaysArgumentAppendAfter
nmap <leader>I <Plug>SidewaysArgumentInsertFirst
nmap <leader>A <Plug>SidewaysArgumentAppendLast

omap <silent> ia <Plug>SidewaysArgumentTextobjI
omap <silent> aa <Plug>SidewaysArgumentTextobjA

" Easy Align - Align by character
nmap <silent> ga :packadd vim-easy-align<CR><Plug>(EasyAlign)
xmap <silent> ga <cmd>packadd vim-easy-align<CR><Plug>(EasyAlign)

" Mundo - Undo Tree Visualizer
nnoremap <silent> yu :packadd vim-mundo <bar> MundoToggle<CR>

" }}}
