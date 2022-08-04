setlocal shiftwidth=2

nnoremap <buffer> cp <Cmd>up <bar> TexlabBuild<CR>

" Title string style used for synctex file matching
let &l:titlestring = '%F %m - NVIM'
