if executable('pandoc')
    let &l:formatprg = 'pandoc -s -t markdown'

    " Preview current document using Pandoc
    nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>
endif

" Insert fenced code block
inoremap <buffer> ``` ```<C-m>```<up>

" Select from list of headers
nnoremap <buffer> gh :g/^#/#<CR>:

" Markdown header jumping (romain-l)
function s:JumpToNextHeading(direction, count) abort
    silent execute a:direction == 'up' ? '?^#' : '/^#'
    if a:count > 1
        silent execute 'normal! ' . repeat('n',
                    \ a:direction == 'up' && col('.')= 1 ? a:count : a:count - 1)
    endif
endfunction

nnoremap <silent><buffer> [[ :call <SID>JumpToNextHeading('up', v:count1)<CR>
nnoremap <silent><buffer> ]] :call <SID>JumpToNextHeading('down', v:count1)<CR>
