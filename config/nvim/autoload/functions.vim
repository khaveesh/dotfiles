" Run formatters with perfect undo history
function functions#Format() abort
    " LSP provided formatting
    if &formatprg ==# 'lsp'
        lua vim.lsp.buf.formatting_sync()

    else
        const original_lines = getbufline(bufnr(), 1, '$')

        if &formatprg ==# ''
            " Trim trailing whitespace and leading blank lines
            const formatted_lines = systemlist(
                        \   "sed 's/[[:space:]]*$//'",
                        \   original_lines
                        \ )
        else
            " Format using CLI tools via stdin
            const formatted_lines = systemlist(&formatprg, original_lines)
        endif

        if v:shell_error != 0
            echoerr 'formatprg exited with error code ' . v:shell_error
        elseif formatted_lines !=# original_lines
            const view = winsaveview()
            lua vim.api.nvim_buf_set_lines(0, 0, -1, true,
                        \ vim.lsp.util.trim_empty_lines(
                        \     vim.api.nvim_eval('formatted_lines')
                        \ ))
            call winrestview(view)
        endif
    endif
endfunction

" Open fuzzy finder in split terminal
function functions#FZTerm(list_command, callback, prompt) abort
    " Open a Neovim terminal emulator buffer in a new window using termopen,
    " execute list_command piping its output to the fuzzy selector, and call
    " callback.on_select with the item selected by the user as the first
    " argument.
    "
    " Parameters
    " ----------
    " list_command : String
    "     Shell command to generate list user will choose from.
    " callback.on_select : String -> Void
    "     Function executed with the item selected by the user as the
    "     first argument.

    const filename = tempname()

    function a:callback.on_exit(job_id, data, event) abort closure
        bdelete!
        setlocal laststatus=2 showmode showcmd
        if filereadable(filename)
            try
                call self.on_select(readfile(filename)[0])
            catch /E684/
            endtry
            call delete(filename)
        endif
    endfunction

    execute 'botright' . &pumheight . 'new'
    const term_command = a:list_command . ' | '
                \ . 'fzy' .  ' -l ' . &pumheight .
                \ ' -p ' . shellescape(a:prompt) . ' > ' . filename
    call termopen(term_command, a:callback)

    setlocal nonumber norelativenumber laststatus=0 noshowmode noshowcmd noruler
    setfiletype picker
    startinsert!
endfunction

" Intuitive prompt (romain-l)
function functions#CCR() abort
    if getcmdtype() != ':'
        return "\<CR>"
    endif
    const cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dli|il)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " .
                    \ split(cmdline, " ")[1] . "\<S-Left>\<Left>"
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

" Toggle Terminal
let s:term_win_id = -1

function functions#ToggleTerminal() abort
    if win_gotoid(s:term_win_id)
        hide
    else
        if bufexists('Terminal')
            vertical sbuffer Terminal
        else
            vnew term://fish
            silent file Terminal
            setlocal norelativenumber nobuflisted
        endif
        let s:term_win_id = win_getid()
        startinsert
    endif
endfunction

" Search documentation on Dash.app
function functions#DevDocs(args) abort
    let query = '!open '
    " let URL = 'https://devdocs.io/#q='
    const URL = 'dash://'

    if len(split(a:args)) == 1
        " let query .= shellescape(URL . &filetype . '%20' . a:args)
        let query .= shellescape(URL . &filetype . '\%3A' . a:args)
    else
        let query .= shellescape(URL . substitute(a:args, '\s\+', '\\%3A', 'g'))
    endif

    return query
endfunction
