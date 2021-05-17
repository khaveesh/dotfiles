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
    highlight statusline guibg=#665c54 guifg=#ebdbb2
    highlight info       guibg=#d5c4a1 guifg=#282828
    highlight warning    guibg=#b57614 guifg=#fbf1c7
    highlight error      guibg=#fbf1c7 guifg=#9d0006

    highlight! link TabLineSel BufTabLineCurrent
endfunction

augroup custom
    autocmd!

    " Prevent the custom highlights from being cleared on reload
    autocmd ColorScheme * call s:Highlight()

    " Use Pandoc Markdown syntax for all md files
    autocmd BufNewFile,BufRead *.md setfiletype markdown.pandoc

    " Format the file before saving (Neovim only)
    autocmd BufWritePre * call functions#Format()
augroup END

" }}}

" EditorConfig {{{

set termguicolors                           " Enable 24-Bit Truecolor
set shell=dash                              " Use POSIX-compliant shell
set gdefault                                " Better substitute
set expandtab softtabstop=4 shiftwidth=4    " Expand tabstops to be 4 spaces
set keywordprg=:DD                          " Search Dash.app for keywords
let &grepprg = 'rg --vimgrep --smart-case'  " Customize grep to use ripgrep

set spelloptions=camel " Spellcheck individual components of CamelCased words

" Completion popup
set completeopt=menuone,noselect
let &pumheight = (&lines - 2) / 3

" Colorscheme
set background=light
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic           = 1
let g:gruvbox_contrast_light   = 'hard'
colorscheme gruvbox

" Disable unused providers to reduce startup time
let g:loaded_node_provider    = 0
let g:loaded_perl_provider    = 0
let g:loaded_python_provider  = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider    = 0

" NerdTree style netrw
let g:netrw_banner       = 0
let g:netrw_browse_split = 2
let g:netrw_liststyle    = 3
let g:netrw_winsize      = 25

" }}}

" Statusline {{{

" Left section
let &statusline = '%#statusline# %m %f %h%w   '
let &statusline .= '%{' .
            \ "&bl && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1"
            \ . "? '[Buffers Listed]' : '' }"

let &statusline .= '%='

" Right section
" Git Status
let &statusline .= "%{ exists('b:gitsigns_status')"
            \              "? ' ' . b:gitsigns_status : '' }"
" Position info
let &statusline .= ' %#info# %l,%c | %P '

" }}}

" Keymappings {{{

" Use spacebar as leader
let mapleader = "\<Space>"
nnoremap <Space> <nop>

" Map unused large sized normal mode keys to useful functions
nnoremap <BS> <C-^>
nnoremap \ <C-w>
map <Tab> %
map <S-Tab> g%

" Clear search highlighting
noremap <C-l> <cmd>nohlsearch<CR><C-l>

" Call macro
nnoremap Q @q

" Edit recorded macros
nnoremap cm :<C-r>='let @'.v:register.'='.string(getreg(v:register))<CR><C-f><left>

" Toggle netrw
nnoremap <silent> yd :Lexplore<CR>

" Toggle spell check
nnoremap ysc :setlocal <C-R>=&spell ? 'nospell' : 'spell'<CR><CR>

" Jetpack mapping - Fast switch, split or unload buffers
nmap gb :ls<CR>
nnoremap gB :ls<CR>:vert sb

" View register contents
nnoremap gr :registers<CR>
inoremap <M-r> <cmd>registers<CR>

" Quick copy/delete into system clipboard
nnoremap cy "+y
nnoremap cd "+d
xnoremap cy "+y
xnoremap cd "+d

" Toggle Quickfix & Location Lists
nnoremap <silent><expr> <leader>q
            \ empty(filter(getwininfo(), 'v:val.quickfix'))
            \ ? ':cwindow<CR>' : ':cclose<CR>'
nnoremap <silent><expr> <leader>l
            \ empty(filter(getwininfo(), 'v:val.loclist'))
            \ ? ':lwindow<CR>' : ':lclose<CR>'

" Echo current file's info
nnoremap <leader>f :echo "\t" &ft &fenc &ff<CR>

" Reload init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Quick save & exit
nnoremap <leader>w :up<CR>
nnoremap <leader>W mwgg=G`w:up<CR>
nnoremap <leader>e :q<CR>
nnoremap <leader>E :qa<CR>
nnoremap <silent> <C-q> :bd<CR>
nnoremap <silent> <M-q> :bd!<CR>

" Better in-buffer search
set wildcharm=<C-z>
cnoremap <expr> <Tab>   getcmdtype() =~ '[\/?]' ? "<C-g>" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[\/?]' ? "<C-t>" : "<S-Tab>"

" Clear search highlighting or call CCR
cnoremap <expr> <CR> getcmdtype() =~ '[\/?]' ? "<CR><C-l>" : functions#CCR()

" Use CCR to provide intuitive auto prompt
nnoremap gm :g//#<left><left>
nmap <leader>m :marks<CR>
nmap <leader>j :jumps<CR>
nmap <leader>Q :clist<CR>
nmap <leader>L :llist<CR>
nnoremap <leader>o :browse oldfiles<CR>

" Toggle Terminal
tnoremap <ESC> <C-\><C-n>
nnoremap <M-z> :call functions#ToggleTerminal()<CR>
tnoremap <silent> <M-z> <C-\><C-n>:call functions#ToggleTerminal()<CR>

" }}}

" Commands {{{

" Better grep command (romain-l)
function s:Grep(...) abort
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:Grep(<f-args>) | cw
cnoreabbrev <expr> grep
            \ (getcmdtype() == ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" Look up documentation in Dash.app
command -nargs=+ DD silent execute functions#DevDocs(<q-args>)

" Clean->Install->Update neovim packages
command VP execute 'vsplit | terminal '.stdpath('config').'/nvim_packer.py'

" }}}

" Plugins {{{

let g:packages = []

function s:packadd(pack, args = {}) abort
    if empty(a:args)
        call add(g:packages, [a:pack, { 'type': 'start' }])
    else
        call add(g:packages, [a:pack, a:args])
    endif
endfunction

command -buffer -nargs=+ Pack call s:packadd(<args>)

" Neovim only plugins {{{

" Sensible Defaults
Pack 'khaveesh/nvim-sensibly-opinionated-defaults'

" LSP - Actions & Completion
Pack 'neovim/nvim-lspconfig'
Pack 'hrsh7th/nvim-compe'

" Semantic syntax highlight & Textobjs
Pack 'nvim-treesitter/nvim-treesitter'
Pack 'nvim-treesitter/nvim-treesitter-textobjects'

" Git Gutter
Pack 'nvim-lua/plenary.nvim'
Pack 'lewis6991/gitsigns.nvim'

" }}}

" Essentials
Pack 'khaveesh/vim-fish-syntax'
Pack 'vim-pandoc/vim-pandoc-syntax'
Pack 'hrsh7th/vim-vsnip'
Pack 'gruvbox-community/gruvbox', { 'type': 'opt' }

" Utilities
Pack 'khaveesh/vim-commentary-yank'
Pack 'khaveesh/vim-unimpaired'
Pack 'tpope/vim-surround'
Pack 'tpope/vim-repeat'
Pack 'tommcdo/vim-exchange'

" }}}

" Plugin Configuration & Keymappings {{{

" Initializes configuration for Lua plugins
lua require('init')

" Nvim-Compe
inoremap <expr> <CR>  compe#confirm("\<CR>")
inoremap <expr> <C-e> compe#close("\<C-e>")
inoremap <expr> <C-f> compe#scroll({ 'delta': +4 })
inoremap <expr> <C-d> compe#scroll({ 'delta': -4 })

" vim-vsnip - LSP & VSCode snippets
let g:vsnip_snippet_dir = stdpath('config').'/vsnip'

" Use (s-)tab to:
"   - move to prev/next item in completion menu
"   - jump to prev/next snippet's placeholder
function s:tab() abort
    if pumvisible()
        return "\<C-n>"
    elseif vsnip#available(1)
        return "\<Plug>(vsnip-expand-or-jump)"
    elseif col('.') == 1 || getline('.')[col('.') - 2] =~ '\s'
        return "\<Tab>"
    else
        return compe#complete()
    endif
endfunction

function s:s_tab() abort
    if pumvisible()
        return "\<C-p>"
    elseif vsnip#jumpable(-1)
        return "\<Plug>(vsnip-jump-prev)"
    else
        return "\<S-Tab>"
    endif
endfunction

imap <expr> <Tab> <SID>tab()
smap <expr> <Tab> <SID>tab()
imap <expr> <S-Tab> <SID>s_tab()
smap <expr> <S-Tab> <SID>s_tab()

" Change/Delete surrounding function
nnoremap csf F(cb
nmap dsf dsbdb

" Some niceties on top of vim-commentary
nnoremap co ox<ESC>:Commentary<CR>W"_s
nnoremap cO Ox<ESC>:Commentary<CR>W"_s
nnoremap cA ox<ESC>:Commentary<CR>k$J2W"_s

" Invert comments for given range
xnoremap <silent> gcy :g/./Commentary<CR>:set nohlsearch<CR>
nnoremap <silent> gcy :set opfunc=<SID>InvertComment<CR>g@
function s:InvertComment(type) abort
    execute "'[,']g/./Commentary"
endfunction

" }}}
