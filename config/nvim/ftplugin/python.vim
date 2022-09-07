let b:formatprg = [ [ 'isort', '-' ], [ 'black', '-' ] ]

nnoremap <buffer> gp <Cmd>up <bar>
      \ lua require('make')({ 'flake8' ,  'pylint' ,  'mypy' }, 'PyLint')<CR>

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
