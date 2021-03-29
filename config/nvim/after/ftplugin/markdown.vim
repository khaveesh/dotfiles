let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin .= ' | unlet! b:pear_tree_pairs'

let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
            \ '---': {'closer': '---'},
            \ }, 'keep')

let &cpoptions = s:save_cpo
unlet s:save_cpo


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

" Cite as you Write using Zotero database
nnoremap <silent><buffer> cz :call functions#ZoteroCite()<CR>
inoremap <silent><buffer> <C-z> <cmd>call functions#ZoteroCite()<CR>

" Preview current document using Pandoc
nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>
