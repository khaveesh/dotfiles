" Run formatters with perfect undo history
function functions#Format() abort
    " LSP provided formatting
    if &formatprg == 'lsp'
        lua vim.lsp.buf.formatting_sync()

    else
        const original_lines = getbufline(bufnr(), 1, '$')
        const formatted_lines = systemlist(&formatprg, original_lines)

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
