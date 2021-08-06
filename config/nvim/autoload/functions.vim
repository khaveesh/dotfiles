" Run formatters with perfect undo history
function functions#Format() abort
    " LSP provided formatting
    if &formatprg == 'lsp'
        lua vim.lsp.buf.formatting_sync()

    else
        const original_lines = getbufline(bufnr(), 1, '$')

        if empty(&formatprg)
            " Trim trailing whitespace and leading blank lines
            const formatted_lines = systemlist(
                        \   "sed 's/[[:space:]]*$//'",
                        \   original_lines
                        \ )
        else
            " Format using CLI tools via stdin
            const formatted_lines = systemlist(&formatprg, original_lines)
        endif

        if v:shell_error
            throw join(formatted_lines)
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
                \ . 'fzy' .  ' -l ' . &pumheight . ' -p '
                \ . shellescape(a:prompt) . ' > ' . filename
    call termopen(term_command, a:callback)

    setlocal nonumber norelativenumber laststatus=0 noshowmode noshowcmd noruler
    tnoremap <buffer> <Esc> <Esc>
    setfiletype picker
    startinsert!
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

" Search documentation
function functions#DevDocs(args) abort
    let query = '~/.config/AppleScripts/DevDocs.applescript '
    const URL = 'https://devdocs.io/#q='

    if len(split(a:args)) == 1
        let query .= shellescape(URL . &filetype . '%20' . a:args)
    else
        let query .= shellescape(URL . substitute(a:args, '\s\+', '%20', 'g'))
    endif

    return query
endfunction
