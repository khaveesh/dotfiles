set shiftwidth=4

let b:formatprg = [ [ 'isort', '-' ], [ 'black', '-' ] ]

nnoremap <buffer> gx :up <bar> vsp <bar> term python %:S<CR>:startinsert<CR>

command -buffer Lint
            \ lgetexpr system(expandcmd('flake8 %:S; echo; pylint %:S; mypy %:S'))
            \ | call setloclist(0, [], 'a', { 'title': 'Pylint: '.expand('%') })
            \ | lwindow

nnoremap <silent><buffer> gl :up <bar> Lint <CR>

" Snippetized docstrings for functions
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

nnoremap <silent><buffer> cp j:call <SID>PyDoc()<CR>
