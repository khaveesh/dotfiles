let b:formatprg = [ 'black', '-' ]

nnoremap <buffer> gp <Cmd>up <bar>
      \ lua require('make')({ 'pylint', 'mypy' }, 'Lint')<CR>

" Snippetized docstring for functions
function s:PyDoc() abort
  ?def
  const firstline = line('.')
  normal ]M
  const lastline = line('.')
  const lines = bufnr()->getbufline(firstline, lastline)
  call bufnr()->deletebufline(firstline, lastline)
  const cmd = 'doq --omit self -t '.stdpath('config').'/doq-google-template'
  call vsnip#anonymous(system(cmd, lines))
endfunction

nnoremap <buffer> cp j<Cmd>call <SID>PyDoc()<CR>
