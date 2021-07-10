let &l:formatprg = 'pandoc -s -t markdown'

" Fuzzy select from references
function s:Cite(mode) abort
    let callback = {}

    function callback.on_select(content) abort closure
        if a:content != ''
            const key = a:content[0 : match(a:content, ':') - 1]
            const cite_key = '[@' . key . ']'
            if a:mode == 'i'
                call feedkeys('a'.cite_key, 'n')
            else
                execute 'normal! i' . cite_key
            endif
        endif
    endfunction

    let refs = json_decode(system('json_xs -f yaml < references.yaml'))['references']
    let pairs = ''
    for ref in refs
        let pairs .= ref['id'] . ': ' . ref['title'] . '\n'
    endfor

    call functions#FZTerm('echo ' . shellescape(pairs), callback, '> ')
endfunction

nnoremap <silent><buffer> cr :call <SID>Cite('n')<CR>
inoremap <silent><buffer> <C-c> <C-o>:call <SID>Cite('i')<CR>

" Markdown header jumping (romain-l)
function s:JumpToNextHeading(direction, count) abort
    const col = col('.')

    silent execute a:direction == 'up' ? '?^#' : '/^#'

    if a:count > 1
        silent execute 'normal! ' . repeat('n',
                    \ a:direction == 'up' && col != 1 ? a:count : a:count - 1)
    endif

    silent execute 'normal! ' . col . '|'
endfunction

nnoremap <silent><buffer> [[ :call <SID>JumpToNextHeading('up', v:count1)<CR>
nnoremap <silent><buffer> ]] :call <SID>JumpToNextHeading('down', v:count1)<CR>

" Select from list of headers
nmap <leader>h :g/^#/#<CR>

" Preview current document using Pandoc
nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>

" Insert fenced code block
inoremap <buffer> ``` ```<C-m>```<up>
