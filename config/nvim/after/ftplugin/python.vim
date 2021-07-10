let &l:formatprg = 'isort - | black -'

setlocal keywordprg=:DD

nnoremap <buffer> gx :up <bar> vsp <bar> term python %:S<CR>:startinsert<CR>

command Lint lgetexpr system(expandcmd('flake8 %:S;echo; pylint %:S; mypy %:S'))
            \ | call setloclist(0, [], 'a', { 'title': 'Pylint: '.expand('%') })
            \ | lwindow

nnoremap <silent><buffer> gl :up <bar> Lint<CR>

function s:PyDoc() abort
    ?def
    const firstline = line('.')
    normal ]M
    const lastline = line('.')
    const lines = getbufline(bufname(), firstline, lastline)
    call deletebufline(bufname(), firstline, lastline)
    const cmd = 'doq --omit self -t '.stdpath('config').'/doq-google-template'
    call vsnip#anonymous(system(cmd, lines))
endfunction

nnoremap <silent><buffer> cp j:call <SID>PyDoc()<CR>
