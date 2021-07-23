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

function s:packadd(pack, args = {}) abort
    if empty(a:args)
        " Default type is 'start'
        call add(g:packages, [a:pack, { 'type': 'start' }])
    else
        call add(g:packages, [a:pack, a:args])
    endif
endfunction

command -buffer -nargs=+ Pack call s:packadd(<args>)

" Lua Plugins {{{

" Sensible Defaults
Pack 'khaveesh/nvim-sensibly-opinionated-defaults'

" LSP - Language Services & Completion
Pack 'neovim/nvim-lspconfig'
Pack 'hrsh7th/nvim-compe'

" Semantic highlighting & text-objects
Pack 'nvim-treesitter/nvim-treesitter'
Pack 'nvim-treesitter/nvim-treesitter-textobjects'

" Git Gutter
Pack 'nvim-lua/plenary.nvim'
Pack 'lewis6991/gitsigns.nvim'

" }}}

" Essentials {{{

" Syntax files
Pack 'khaveesh/vim-fish-syntax'
Pack 'vim-pandoc/vim-pandoc-syntax'

" Color Scheme
Pack 'gruvbox-community/gruvbox', { 'type': 'opt' }
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

" Comment & uncomment lines
Pack 'khaveesh/vim-commentary-yank'

" Handy square bracket mappings
Pack 'khaveesh/vim-unimpaired'

" Manipulate surrounding delimiters
Pack 'tpope/vim-surround'

" Dot-repeat support for plugins
Pack 'tpope/vim-repeat'

" Text exchange operator
Pack 'tommcdo/vim-exchange'

" }}}

" }}}

" Autocmds {{{

augroup custom | autocmd!
    " Prevent custom highlights from being cleared on reload
    autocmd ColorScheme GruvBox
                \ highlight Error guibg=#fbf1c7 guifg=#9d0006
                \ | highlight Warning guibg=#b57614 guifg=#fbf1c7

    " Use Pandoc Markdown syntax for all .md files
    autocmd BufNewFile,BufRead *.md setfiletype markdown.pandoc

    " Format the file before saving
    autocmd BufWritePre * call functions#Format()
augroup END

" }}}

" EditorConfig {{{

set termguicolors                     " Enable 24-Bit Truecolor
set shell=dash                        " Use POSIX-compliant shell
set gdefault                          " Better substitute
set expandtab tabstop=4 shiftwidth=4  " Expand tab stops to be 4 spaces
set spelloptions=camel                " Spell check camelCased components

" Completion popup
set completeopt=menuone,noselect
let &pumheight = (&lines - 5) / 3

" Use ripgrep as grep program
let &grepprg = 'rg --vimgrep --smart-case'

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

" Keymaps {{{

" Use space as leader
nnoremap <Space> <nop>
let mapleader = ' '

" Call macro recorded in register q
nnoremap Q @q

" Edit recorded macro
nnoremap cm :let @<C-r>=v:register.'='.string(getreg(v:register))<CR><C-f><left>

" Toggle netrw
nnoremap <silent> yd :Lexplore<CR>

" Toggle spell check
nnoremap zy :syntax match SingleChar '\<\A*\a\A*\>' contains=@NoSpell<CR>:
            \ setlocal <C-r>=&spell ? 'nospell' : 'spell'<CR><CR>

" Jetpack mapping - Fast switch, split or unload buffers
nmap gb :ls<CR>
nnoremap gB :ls<CR>:vert sb

" View register contents
nnoremap gr :registers<CR>
noremap! <M-r> <cmd>registers<CR>

" Clear search highlighting
nnoremap <C-l> :nohlsearch<CR><C-l>
vnoremap <C-l> <cmd>nohlsearch<CR><C-l>

" Map unused large size normal mode keys to useful functions
nnoremap <BS> <C-^>
nnoremap \ <C-w>
map <Tab> %
map <S-Tab> g%

" Quick copy/delete into system clipboard
nnoremap cd "+d
nnoremap cy "+y
xnoremap cd "+d
xnoremap cy "+y

" Echo file info
nnoremap <leader>f :echo "\t" &ft &fenc &ff<CR>

" Reload init.vim
nnoremap <leader>v :source ~/.config/nvim/init.vim<CR>

" Substitute the word under the cursor.
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Toggle Quickfix & Location lists
nnoremap <silent><expr> <leader>l
            \ empty(filter(getwininfo(), 'v:val.loclist'))
            \ ? ':lwindow<CR>' : ':lclose<CR>'
nnoremap <silent><expr> <leader>q
            \ empty(filter(getwininfo(), 'v:val.quickfix'))
            \ ? ':cwindow<CR>' : ':cclose<CR>'

" Quick save & exit
nnoremap <silent> <leader>w :up<CR>
nnoremap <silent> <leader>W mwgg=G`w:up<CR>
nnoremap <silent> <leader>e :q<CR>
nnoremap <leader>E :qa<CR>
nnoremap <silent> <C-q> :bd<CR>
nnoremap <silent> <M-q> :bd!<CR>

" Better in-buffer search
set wildcharm=<C-z>
cnoremap <expr> <Tab>   getcmdtype() =~ '[\/?]' ? '<C-g>' : '<C-z>'
cnoremap <expr> <S-Tab> getcmdtype() =~ '[\/?]' ? '<C-t>' : '<S-Tab>'

" Clear search highlighting on <CR>
cnoremap <expr> <CR> getcmdtype() =~ '[\/?]' ? '<CR><cmd>nohlsearch<CR>' : functions#CCR()

" Use CCR to provide intuitive auto prompt
nmap <leader>j :jumps<CR>
nmap <leader>m :marks<CR>
nmap <leader>L :llist<CR>
nmap <leader>Q :clist<CR>
nnoremap gm :g//#<left><left>
nnoremap <leader>o :browse oldfiles<CR>

" Terminal
tnoremap <Esc> <C-\><C-n>
tnoremap <silent> <M-z> <C-\><C-n>:call functions#ToggleTerminal()<CR>
nnoremap <silent> <M-z> :call functions#ToggleTerminal()<CR>

" nvim-compe
inoremap <expr> <CR>  compe#confirm('<CR>')
inoremap <expr> <C-e> compe#close('<C-e>')
inoremap <expr> <C-f> compe#scroll({ 'delta': +4 })
inoremap <expr> <C-d> compe#scroll({ 'delta': -4 })

" vim-vsnip
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

" Use (s-)tab to:
"   - move to prev/next item in completion menu
"   - jump to prev/next snippet's placeholder
imap <expr> <Tab> <SID>tab()
smap <expr> <Tab> <SID>tab()
imap <expr> <S-Tab> <SID>s_tab()
smap <expr> <S-Tab> <SID>s_tab()

" Change/Delete surrounding function
nnoremap csf F(cb
nmap dsf dsbdb

" Some niceties on top of vim-commentary
nnoremap co ox<Esc>:Commentary<CR>W"_s
nnoremap cO Ox<Esc>:Commentary<CR>W"_s
nnoremap cA ox<Esc>:Commentary<CR>k$J2W"_s

" }}}

" Statusline {{{

" File info
let &statusline = '%#StatusLineNC# %m %f %h%w '
" Multiple buffers indicator
let &statusline .= '%{ &bl && '
            \ . "len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1"
            \ . " ? '[Buffers Listed]' : '' }"

let &statusline .= '%='

" Git Status
let &statusline .= "%{ exists('b:gitsigns_status')"
            \             . " ? ' ' . b:gitsigns_status : '' }"
" Position info
let &statusline .= ' %#StatusLine# %l,%c │ %P '

" }}}

" Commands {{{

" Look up documentation in Dash.app
command -nargs=+ DD silent execute functions#DevDocs(<q-args>)
set keywordprg=:DD

" Better grep command (romain-l)
command -nargs=+ -complete=file_in_path -bar Grep cgetexpr s:Grep(<f-args>) | cw

function s:Grep(...) abort
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

cnoreabbrev <expr> grep
            \ (getcmdtype() == ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'

" }}}
