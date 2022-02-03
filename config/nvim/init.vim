" vim: foldmethod=marker

" EditorConfig {{{

set gdefault            " Better substitute
set pumheight=15        " Completion popup max height
set spelloptions=camel  " Spell check camelCased components

" NerdTree style netrw
let g:netrw_banner    = 0
let g:netrw_liststyle = 3
let g:netrw_winsize   = 25

" Format before saving the file
autocmd! BufWritePre * lua require('format')()

" Color Scheme
set termguicolors
set background=light
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic           = 1
let g:gruvbox_contrast_light   = 'hard'
colorscheme gruvbox
highlight! default link LspSignatureActiveParameter WarningMsg

" VSCode/LSP snippets
let g:vsnip_snippet_dir = stdpath('config').'/vsnip'

" }}}

" Keymaps {{{

" Format and update
nnoremap gw :up<CR>

" Edit recorded macro
nnoremap cm :let @<C-r>=v:register.'='.string(getreg(v:register))<CR><C-f><left>

" Toggle netrw
nnoremap <silent> yd :Lexplore<CR>

" Toggle spell check
nnoremap yz :syntax match SingleChar '\<\A*\a\A*\>' contains=@NoSpell<CR>
            \ :setlocal <C-r>=&spell ? 'nospell' : 'spell'<CR><CR>

" Jetpack mapping - Fast switch, split or unload buffers
nnoremap gb :ls<CR>:b
nnoremap gB :ls<CR>:vert sb

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

" Substitute the word under the cursor
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>
nnoremap <leader>S :%s/\<<C-r><C-w>\>/<C-r><C-w>

" Buffer unload
nnoremap <silent> <leader>q :bd<CR>
nnoremap <silent> <leader>Q :bd!<CR>

" Toggle Quickfix & Location lists
nnoremap <silent><expr> <leader>c
            \ empty(getwininfo()->filter('v:val.quickfix'))
            \ ? ':cwindow<CR>' : ':cclose<CR>'
nnoremap <silent><expr> <leader>l
            \ empty(getwininfo()->filter('v:val.loclist'))
            \ ? ':lwindow<CR>' : ':lclose<CR>'

" Auxiliary Comment maps
nnoremap co ox<Esc>:Comment<CR>W"_s
nnoremap cO Ox<Esc>:Comment<CR>W"_s
nnoremap cA ox<Esc>:Comment<CR>k$J2W"_s

" }}}

" Statusline {{{

autocmd BufAdd,BufWipeout,BufWinEnter * let g:bufs_listed =
            \ &bl && len(getbufinfo({ 'buflisted': 1 })) > 1
            \ ? '[Buffers Listed]' : ''

" File info & Multiple buffers indicator
let &statusline = '%#StatusLineNC# %m %f %h%w  %{g:bufs_listed}'

" Position info
let &statusline .= '%=%#StatusLine# %l,%c │ %P '

" }}}
