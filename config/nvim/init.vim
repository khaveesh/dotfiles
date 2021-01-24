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
function! s:Highlight() abort
    " Gruvbox Light colors
    hi statusline guibg=#504945 guifg=#ebdbb2
    hi info       guibg=#d5c4a1 guifg=#282828
    hi warning    guibg=#b57614 guifg=#fbf1c7
    hi error      guibg=#fbf1c7 guifg=#9d0006

    hi! link TabLineSel BufTabLineCurrent
endfunction

augroup custom
    autocmd!

    " Prevent the highlights from being cleared on reload
    autocmd ColorScheme * call s:Highlight()

    " Completion (Neovim only)
    autocmd BufEnter * lua require'completion'.on_attach()
    " Load snippets on entering insert mode
    autocmd InsertEnter * ++once packadd vim-snippets | packadd ultisnips

    " Format the file before saving (Neovim only)
    autocmd BufWritePre * call functions#Format()

    " Update location list on diagnostics change (Neovim only)
    autocmd User LspDiagnosticsChanged
                \ lua vim.lsp.diagnostic.set_loclist({open_loclist = false})

    " Reset cursor shape on exit & restore on resume (Neovim only)
    autocmd VimSuspend          * let s:default_gc = &guicursor
    autocmd VimLeave,VimSuspend * set guicursor=n:ver25-blinkon100
    autocmd VimResume           * let &guicursor = s:default_gc
augroup END

" }}}


" EditorConfig {{{

set termguicolors                              " Enable 24-Bit Truecolor
set shell=dash                                 " Use POSIX-compliant shell
set grepprg=rg\ --vimgrep\ --smart-case        " Customize grep to use ripgrep
set expandtab tabstop=4 shiftwidth=4           " Expand tabstops to be 4 spaces
set gdefault                                   " Better substitute
set nojoinspaces                               " One space after punctuation on join
set pumheight=12 completeopt=menuone,noinsert  " Completion
set keywordprg=:DD                             " Search Dash.app for keywords

" Colorscheme
set background=light
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_light   = 'hard'
colorscheme gruvbox

" let g:nord_underline       = 1
" let g:nord_italic          = 1
" let g:nord_italic_comments = 1
" colorscheme nord

Statusline
set statusline=%#statusline#\ %m\ %f\ %h%w%=
set statusline+=%{functions#Buffers()}\ \ %{functions#GitStatus()}
set statusline+=\ \ %#info#\ \ %l\ \:\ %c\ \|\ %P
set statusline+=\ %#error#%{functions#LspErrors()}
set statusline+=%#warning#%{functions#LspWarnings()}

" }}}


" Editor Variables {{{

" Setting the python path reduces startup time
let g:python3_host_prog = '/usr/bin/python3'
" Disable unused providers
let g:loaded_python_provider = 0
let g:loaded_ruby_provider   = 0
let g:loaded_perl_provider   = 0
let g:loaded_node_provider   = 0

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_browse_split = 2
let g:netrw_liststyle    = 3
let g:netrw_winsize      = 25

" Markdown fenced languages syntax highlighting
let g:markdown_fenced_languages = ['python']

" }}}


" Keymappings {{{

" Use <tab> for completion navigation
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Toggle Quickfix & Location Lists
nnoremap <silent> <expr> <leader>e
            \ empty(filter(getwininfo(), 'v:val.quickfix')) ? ':copen<CR>' : ':cclose<CR>'
nnoremap <silent> <expr> <leader>l
            \ empty(filter(getwininfo(), 'v:val.loclist'))  ? ':lopen<CR>' : ':lclose<CR>'

" Call macro
nnoremap Q @q

" Toggle netrw
nnoremap <silent> <C-n> :Lexplore<CR>

" Preview current document using Pandoc
nnoremap <silent> <leader>p :silent exe "%w !fish -c 'panhtml -f ".&ft."'"<CR>

" Jetpack mapping - Fast switch, split or unload buffers
nnoremap <leader>b :ls<CR>:b
nnoremap <leader>V :ls<CR>:vsp\|b

" Echo current file's info
nnoremap <leader>i :echo "\t" &ft &fenc &ff<CR>

" Edit recorded macros
nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" Reload init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Substitute the word under the cursor.
nnoremap <leader>s  :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S  :%s/<C-r><C-w>/
nnoremap <leader>ss :%s/\<<C-r><C-w>\>/<C-r><C-w>
nnoremap <leader>SS :%s/\<<C-r><C-w>\>/

" Quick copy/delete into system clipboard
nnoremap <leader>y "+y
nnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>d "+d

" Quick window switching
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" Quick save & exit
nnoremap <leader>w  :w<CR>
nnoremap <leader>ww :normal! gg=G<C-o><CR>:w<CR>
nnoremap <leader>q  :q<CR>
nnoremap <leader>qa :qa<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq ZQ
nnoremap <silent> <C-q> :bd<CR>

" Some niceties on top of vim-commentary & vim-surround
nmap co ox<Esc>gcc0fx"_cl
nmap cO Ox<Esc>gcc0fx"_cl
nmap cA ox<Esc>gcc$kJfx"_cl

nmap dsf dsbdb
nmap csf F(cb

" }}}


" Commands {{{

" Better grep command
function! s:Grep(...) abort
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:Grep(<f-args>) | cw
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" Look up documentation in Dash.app
command! -nargs=+ DD call system(functions#DevDocs(<q-args>))

" }}}


" Plugins {{{

" Packager - Plugin Manager
function! s:packager_init(packager) abort

    " Manage packager as optional plugin
    call a:packager.add('kristijanhusak/vim-packager', {'type': 'opt'})

    " Neovim only plugins {{{

    " Defaults
    call a:packager.add('khaveesh/nvim-sensibly-opinionated-defaults')

    " Tab Completion - LSP & other sources
    call a:packager.add('nvim-lua/completion-nvim',
                \         {'requires': 'neovim/nvim-lspconfig'})

    " Syntax highlight & Semantic textobjs
    call a:packager.add('nvim-treesitter/nvim-treesitter', {
                \     'requires': 'nvim-treesitter/nvim-treesitter-textobjects',
                \     'do': ':TSUpdate'
                \ })

    " Git Gutter
    call a:packager.add('lewis6991/gitsigns.nvim',
                \         {'requires': 'nvim-lua/plenary.nvim'})

    " }}}

    " Colour Schemes
    call a:packager.add('gruvbox-community/gruvbox', {'type': 'opt'})
    call a:packager.add('arcticicestudio/nord-vim', {'type': 'opt'})

    " Syntax files
    call a:packager.add('khaveesh/vim-fish-syntax')

    " Snippets
    call a:packager.add('honza/vim-snippets', {
                \         'type': 'opt',
                \         'requires': [['SirVer/ultisnips', {'type': 'opt'}]]
                \ })

    " Utilities
    call a:packager.add('khaveesh/vim-unimpaired')
    call a:packager.add('tpope/vim-surround')
    call a:packager.add('tpope/vim-repeat')
    call a:packager.add('CherryMan/vim-commentary-yank')
    call a:packager.add('tmsvg/pear-tree')
    call a:packager.add('AndrewRadev/sideways.vim')
    call a:packager.add('romainl/vim-cool')
    call a:packager.add('junegunn/vim-easy-align', {'type': 'opt'})
    call a:packager.add('simnalamburt/vim-mundo', {'type': 'opt'})

endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'),
            \         {'dir': stdpath('data') . '/site/pack/packager'})

" }}}


" Plugin Configuration {{{

" Initializes configuration for Lua plugins
lua require'init'

" LSP server-specific mappings
nnoremap <silent> <leader>t :w<CR>:TexlabBuild<CR>
nnoremap <silent> <leader>h :ClangdSwitchSourceHeader<CR>

" Completion
let g:completion_chain_complete_list = {
            \  'fish': [
            \      {'complete_items': ['fish', 'snippet']},
            \      {'mode': '<c-p>'},
            \      {'mode': '<c-n>'},
            \      {'complete_items': ['path']}
            \  ],
            \  'default': [
            \      {'complete_items': ['lsp', 'snippet']},
            \      {'mode': '<c-p>'},
            \      {'mode': '<c-n>'},
            \      {'complete_items': ['path']}
            \  ],
            \ }
let g:completion_enable_auto_hover  = 0
let g:completion_enable_auto_paren  = 1
let g:completion_auto_change_source = 1
let g:completion_abbr_length        = 60
let g:completion_enable_snippet     = 'UltiSnips'

" Pear Tree - Auto pair closing
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1
" Restore <CR> for Completion confirmation
imap <nop> <Plug>(PearTreeExpand)
let g:completion_confirm_key = ''
imap <expr> <CR> pumvisible() ? complete_info()['selected'] != '-1' ?
            \ "\<Plug>(completion_confirm_completion)" : "\<C-e>\<CR>" : "\<Plug>(PearTreeExpand)"

" Sideways - Shift and insert arguments
nnoremap <silent> [a :SidewaysLeft<CR>
nnoremap <silent> ]a :SidewaysRight<CR>

nmap <leader>si <Plug>SidewaysArgumentInsertBefore
nmap <leader>sa <Plug>SidewaysArgumentAppendAfter
nmap <leader>sI <Plug>SidewaysArgumentInsertFirst
nmap <leader>sA <Plug>SidewaysArgumentAppendLast

omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" Easy Align - Align by character
nmap ga :packadd vim-easy-align<CR><Plug>(EasyAlign)
xmap ga <cmd>packadd vim-easy-align<CR><Plug>(EasyAlign)

" Mundo - Undo Tree Visualizer
nnoremap <silent> <F5> :packadd vim-mundo<CR>:MundoToggle<CR>

" Ultisnips - Snippets
" Since Completion uses <tab>, change trigger key
let g:UltiSnipsExpandTrigger = "\<C-l>"

" }}}
