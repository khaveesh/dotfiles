" Markdown header jumping (romain-l)
function s:JumpToNextHeading(direction, count) abort
    let col = col('.')

    silent execute a:direction == 'up' ? '?^#' : '/^#'

    if a:count > 1
        silent execute 'normal! ' . repeat('n', a:direction == 'up' && col != 1 ? a:count : a:count - 1)
    endif

    silent execute 'normal! ' . col . '|'

    unlet col
endfunction

nnoremap <silent><buffer> ]] :<C-u>call <SID>JumpToNextHeading('down', v:count1)<CR>
nnoremap <silent><buffer> [[ :<C-u>call <SID>JumpToNextHeading('up', v:count1)<CR>


let &l:formatprg = 'pandoc -s -t markdown'

" Fuzzy select from references
function s:Cite(mode) abort
    let callback = {}

    function callback.on_select(content) abort closure
        if !empty(a:content)
            let key = a:content[0 : match(a:content, ':') - 1]
            let cite_key = '[@' . key . ']'
            if a:mode == 'i'
                call feedkeys('a'.cite_key, 'n')
            else
                execute 'normal! i' . cite_key
            endif
        endif
    endfunction

    call functions#FZTerm(stdpath('config').'/pick.py', callback, 'References> ')
endfunction

nnoremap <silent><buffer> cr :call <SID>Cite('n')<CR>
inoremap <silent><buffer> <C-c> <ESC>:call <SID>Cite('i')<CR>

" Preview current document using Pandoc
nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>
