# Defined in - @ line 1
function panpdf --wraps=pandoc --description 'Convert pandoc file formats to LaTeX-style PDF'
    set author 'Khaveesh N'
    pandoc -s -L refnos.lua \
        --pdf-engine=latexmk --pdf-engine-opt='-lualatex' \
        -C --csl=ieee -M link-citations \
        -V documentclass=scrartcl -V lang=en-GB \
        -V csquotes -V urlcolor=[HTML]{1A0DAB} \
        -V title=$argv[3] -V title-meta=$argv[3] \
        -V author=$author -V author-meta=$author \
        $argv[1] -o $argv[2] \
        $argv[4..]
end
