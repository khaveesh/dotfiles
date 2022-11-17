let b:formatprg = [ [ 'pandoc', '--standalone', '--to=markdown', '--columns=90' ] ]

" Preview current document using Pandoc
nnoremap <buffer> <leader>p <Cmd>up <bar> silent !fish -c 'panhtml %:S'<CR>

" Select from list of headers
nnoremap <buffer><expr> gh '<Cmd>g/^#/#<CR>:'

" Markdown header jumping (romain-l)
function s:JumpHeading(direction, count) abort
  if a:count > 1
    return repeat('n', a:direction=='up' && col('.') != 1 ? a:count : a:count-1)
  endif
endfunction

nnoremap <buffer><silent><expr> [[ '?^#<CR>'.<SID>JumpHeading('up', v:count1)
nnoremap <buffer><silent><expr> ]] '/^#<CR>'.<SID>JumpHeading('down', v:count1)
