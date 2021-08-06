" Use Pandoc Markdown syntax for all .md files
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
