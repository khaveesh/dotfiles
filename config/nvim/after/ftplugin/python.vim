setlocal keywordprg=:DD

let &l:formatprg = 'isort - | black -'

nnoremap <buffer> gx :up <bar> vsp <bar> term python %:S<CR>:startinsert<CR>

command! Lint lgetexpr
            \ system(expandcmd('flake8 %:S; echo; pylint %:S; mypy %:S'))
            \ | call setloclist(0, [], 'a', {'title' : 'Pylint: '.expand('%')})
            \ | lwindow
nnoremap <silent><buffer> gl :up <bar> Lint<CR>

function s:PyDoc() range abort
    let lines = getbufline(bufname(), a:firstline, a:lastline)
    call deletebufline(bufname(), a:firstline, a:lastline)
    let cmd = 'doq --omit self -t ' . stdpath('config') . '/doq-google-template'
    call vsnip#anonymous(system(cmd, lines))
endfunction
nmap <silent><buffer> cp $vaf:call <SID>PyDoc()<CR>
