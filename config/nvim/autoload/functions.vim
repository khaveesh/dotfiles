" Autoloaded Functions


" FileType specifications
let s:lsp_ft = ['c', 'cpp', 'python']
let s:formatprg_ft = {
            \  'fish':     'fish_indent',
            \  'markdown': 'pandoc -s -t markdown-fenced_code_attributes',
            \  'tex':      'latexindent -c=/tmp/'
            \ }

" Run formatters with perfect undo history
function! functions#Format() abort
    " LSP provided formatting
    if index(s:lsp_ft, &ft) >= 0
        lua vim.lsp.buf.formatting_sync(nil, 1000)

    else
        let original_lines = getbufline(bufname(), 1, '$')

        if has_key(s:formatprg_ft, &ft)
            " Format using CLI tools via stdin
            let formatted_lines = split(system(s:formatprg_ft[&ft], original_lines), '\n')
        else
            " Trim trailing whitespace and leading blank lines
            let formatted_lines = split(system("sed 's/[ \t]*$//'", original_lines), '\n')
        endif

        if v:shell_error > 0
            echomsg 'formatprg exited with status ' . v:shell_error
        elseif formatted_lines !=# original_lines
            let view = winsaveview()
            lua vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.api.nvim_eval('formatted_lines'))
            call winrestview(view)
        endif
    endif
endfunction


" Search documentation on Dash.app
function! functions#DevDocs(args) abort
    let query = 'open '
    " let URL = 'https://devdocs.io/#q='
    let URL = 'dash://'

    if len(split(a:args, ' ')) == 1
        " let query .= shellescape(URL . &filetype . '%20' . a:args)
        let query .= shellescape(URL . &filetype . '%3A' . a:args)
    else
        let query .= shellescape(URL . substitute(a:args, '\s\+', '%3A', 'g'))
    endif

    return query
endfunction


" Statusline Functions
function! functions#LspErrors() abort
    if index(s:lsp_ft, &ft) >= 0
        let e = luaeval('vim.lsp.diagnostic.get_count(0, [[Error]])')
        return e != 'null' ? ' E:' . e . ' ' : ''
    endif
    return ''
endfunction

function! functions#LspWarnings() abort
    if index(s:lsp_ft, &ft) >= 0
        let w = luaeval('vim.lsp.diagnostic.get_count(0, [[Warning]])')
        return w != 'null' ? "\ua0W:" . w . ' ' : ''
    endif
    return ''
endfunction

function! functions#GitStatus() abort
    return exists('b:gitsigns_status') ? ' ' . b:gitsigns_status : ''
endfunction

function! functions#Buffers() abort
    return len(getbufinfo({'buflisted': 1})) > 1 && &bl ? '[Buffers Listed]' : ''
endfunction
