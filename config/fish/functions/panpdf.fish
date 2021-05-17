# Defined in - @ line 2
function panpdf --wraps=pandoc --description 'Converts pandoc file formats to LaTeX-style PDF'
    set author 'Khaveesh N'
    pandoc --pdf-engine=lualatex -V documentclass=scrartcl --listings -C --csl=ieee -M link-citations $argv[1] -o $argv[2] -V lang=en-GB -V csquotes -V monofont='SF Mono' -V urlcolor=[HTML]{1A0DAB} -V title="$argv[3]" -V title-meta="$argv[3]" -V author=$author -V author-meta=$author -H ~/.local/share/pandoc/listings.tex $argv[4..]
end
