" EditorConfig
set gdefault            " Better substitute
set mousescroll=ver:1   " Smooth scroll
set spelllang=en_gb     " British English
set spelloptions=camel  " Spell check camelCased components

" NerdTree style netrw
let g:netrw_banner  = 0
let g:netrw_winsize = 25

" Statusline - File info & Position info
let &statusline = '%#StatusLineNC# %m %f %h%w'
      \           . '%=%#StatusLine# %l,%c │ %P '

" VSCode/LSP snippets
let g:vsnip_snippet_dir = stdpath('config') . '/vsnip'

" Format and update
nnoremap gw <Cmd>update<CR>

" Toggle netrw
nnoremap yd <Cmd>Lexplore<CR>

" Toggle spell check
nnoremap yz <Cmd>setlocal invspell<CR>

" Jet pack mapping - Fast switch, split or unload buffers
nnoremap gb <Cmd>buffers<CR>:b
nnoremap gB <Cmd>buffers<CR>:vert sb

" Quick exit
nnoremap gq <Cmd>quit<CR>
nnoremap gQ <Cmd>quitall<CR>

" View register contents
nnoremap gr    <Cmd>registers<CR>
inoremap <M-r> <Cmd>registers<CR>
vnoremap <M-r> <Cmd>registers<CR>

" Quick copy/cut into system clipboard
nnoremap cy "+y
nnoremap cd "+d
vnoremap cy "+y
vnoremap cd "+d

" Map unused large size normal mode keys to useful functions
noremap <Tab>   <Plug>(matchup-%)
noremap <S-Tab> <Plug>(matchup-g%)
nnoremap <BS>    <C-^>
nnoremap <Space> <C-w>

" Buffer unload
nnoremap <leader>q <Cmd>bdelete<CR>
nnoremap <leader>Q <Cmd>bdelete!<CR>

" Toggle Quick-fix & Location lists
nnoremap <expr> <leader>c empty(getwininfo()->filter('v:val.quickfix'))
      \                   ? '<Cmd>cwindow<CR>' : '<Cmd>cclose<CR>'
nnoremap <expr> <leader>l empty(getwininfo()->filter('v:val.loclist'))
      \                   ? '<Cmd>lwindow<CR>' : '<Cmd>lclose<CR>'
