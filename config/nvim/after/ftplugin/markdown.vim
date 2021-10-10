if executable('pandoc')
    let &l:formatprg = 'pandoc -s -t markdown'

    " Preview current document using Pandoc
    nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>

    " Fuzzy select from references
    function s:Cite(mode) abort
        let callback = {}

        function callback.on_select(content) abort closure
            if a:content != ''
                const cite_key = '[@' . a:content[0 : match(a:content, ':') - 1] . ']'
                if a:mode == 'i'
                    call feedkeys('i'.cite_key, 'n')
                else
                    execute 'normal! i' . cite_key
                endif
            endif
        endfunction

        const refs = json_decode(system('(echo ---; cat references.yaml; echo ---) | pandoc -t csljson'))
        let pairs = ''
        for ref in refs
            let pairs .= ref['id'] . ': ' . ref['title'] . '\n'
        endfor

        call functions#FZTerm('echo ' . shellescape(pairs), callback, '> ')
    endfunction

    nnoremap <silent><buffer> cr    :call <SID>Cite('n')<CR>
    inoremap <silent><buffer> <M-c> <C-o>:call <SID>Cite('i')<CR>
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
