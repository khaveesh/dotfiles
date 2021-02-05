# Defined in /var/folders/2f/1bkdyqls61b9zgk7m2zdgs6r0000gn/T//fish.LRGEuZ/panpdf.fish @ line 2
function panpdf --wraps=pandoc --description 'Converts pandoc file formats to LaTeX style pdf'
    spell $argv[1]
    set author 'Khaveesh N'
    pandoc --pdf-engine=lualatex --listings -s $argv[1] -o $argv[2] -V documentclass=scrartcl -V lang=en-GB -V linestretch=1.2 -V urlcolor=[HTML]{1A0DAB} -V author=$author -V author-meta=$author -V monofont='SF Mono' -V header-includes='\pdfvariable minorversion 7'\n'\pdfvariable suppressoptionalinfo \numexpr32+64+512\relax'\n'\usepackage{sourcesanspro}' -H $HOME/.local/share/pandoc/listings.tex -V title="$argv[3]" -V title-meta="$argv[3]" $argv[4..-1]
end
