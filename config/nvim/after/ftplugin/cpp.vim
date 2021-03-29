nnoremap <silent><buffer> gx :up <bar> !clang++ -o /tmp/%:t:r:S.out %:S<CR>:vsp <bar> term /tmp/%:t:r:S.out<CR>:startinsert<CR>

nnoremap <silent><buffer> gl :up <bar> vsp <bar> term fish -c 'clang++ -o /tmp/%:t:r:S.out %:S && clang-tidy %:S'<CR>

nnoremap <silent><buffer> gL :lua vim.lsp.diagnostic.set_loclist()<CR>

nnoremap <silent><buffer> <leader>h :ClangdSwitchSourceHeader<CR>
