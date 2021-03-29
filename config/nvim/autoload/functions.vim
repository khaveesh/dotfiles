" Autoloaded Functions

" Run formatters with perfect undo history
function functions#Format() abort
    " LSP provided formatting
    if &formatprg ==# 'lsp'
        lua vim.lsp.buf.formatting_sync(nil, 1000)

    else
        let original_lines = getbufline(bufnr(), 1, '$')

        if &formatprg ==# ''
            " Trim trailing whitespace and leading blank lines
            let formatted_lines = systemlist("sed 's/[[:space:]]*$//'", original_lines)
        else
            " Format using CLI tools via stdin
            let formatted_lines = systemlist(&formatprg, original_lines)
        endif

        if v:shell_error != 0
            echomsg 'formatprg exited with error code ' . v:shell_error
        elseif formatted_lines !=# original_lines
            let view = winsaveview()
            lua vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.lsp.util.trim_empty_lines(vim.api.nvim_eval('formatted_lines')))
            call winrestview(view)
        endif
    endif
endfunction

" Use BetterBibTex's 'cayw' function to insert citations
function functions#ZoteroCite() abort
    " pick a format based on the filetype
    let format = &filetype =~ '.*tex' ? 'biblatex' : 'pandoc'
    let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
    let ref = system('curl -s '.shellescape(api_call))
    silent exe '!open -a kitty'
    if ref != ''
        exe 'normal! i' . ref
    endif
endfunction

" Intuitive prompt (romain-l)
function functions#CCR() abort
    let cmdline = getcmdline()
    if getcmdtype() != ':'
        return "\<CR>"
    endif
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dli|il)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)'
        " like :clist or :llist but prompts for an error/location number
        return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\C^changes'
        " like :changes but prompts for a change to jump to
        return "\<CR>:norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju'
        " like :jumps but prompts for a position to jump to
        return "\<CR>:norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\C^marks'
        " like :marks but prompts for a mark to jump to
        return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol'
        " like :undolist but prompts for a change to undo
        return "\<CR>:u "
    else
        return "\<CR>"
    endif
endfunction

" Search documentation on Dash.app
function functions#DevDocs(args) abort
    let query = 'open '
    " let URL = 'https://devdocs.io/#q='
    let URL = 'dash://'

    if len(split(a:args, ' ')) == 1
        " let query .= shellescape(URL . &filetype . '%20' . a:args)
        let query .= shellescape(URL . &filetype . '\%3A' . a:args)
    else
        let query .= shellescape(URL . substitute(a:args, '\s\+', '\\%3A', 'g'))
    endif

    return query
endfunction
