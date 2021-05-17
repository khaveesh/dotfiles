function s:VimImprovedJoin() abort
    if line('.') != line('$')
        normal! J
        if getline('.')[col('.')] == '\'
            normal! ldwh
        endif
    endif
endfunction

nnoremap <silent><buffer> J :call <SID>VimImprovedJoin()<CR>
