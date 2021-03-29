" Pear Tree - A painless, powerful Vim auto-pair plugin
" Maintainer: Thomas Savage <thomasesavage@gmail.com>
" Version: 0.8
" License: MIT
" Website: https://github.com/tmsvg/pear-tree

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin .= ' | unlet! b:pear_tree_pairs'

let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
            \ '\\begin{*}': {'closer': '\\end{*}', 'until': '[{}[:space:]]'},
            \ '$$': {'closer': '$$'},
            \ '$': {'closer': '$'},
            \ '\\(': {'closer': '\\)'},
            \ '\\{': {'closer': '\\}'},
            \ '\\[': {'closer': '\\]'},
            \ }, 'keep')

let &cpoptions = s:save_cpo
unlet s:save_cpo


" Cite as you Write using Zotero database
nnoremap <silent> cz :call functions#ZoteroCite()<CR>
inoremap <silent> <C-z> <cmd>call functions#ZoteroCite()<CR>

" Preview current document using Pandoc
nnoremap <silent><buffer> <leader>p :up <bar> silent !fish -c 'panhtml %:S'<CR>

nnoremap <silent><buffer> <leader>t :up <bar> TexlabBuild<CR>
