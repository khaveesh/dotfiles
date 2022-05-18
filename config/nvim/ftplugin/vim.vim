" Eliminate leading backslashes on Vim script line joins
function s:VimImprovedJoin() abort
    let line_no = line('.')
    if line_no != line('$')
        if getline(line_no + 1)->matchstr('\S') == '\'
            return 'Jldw'
        endif
        return 'J'
    endif
endfunction

nnoremap <buffer><expr> J <SID>VimImprovedJoin()
