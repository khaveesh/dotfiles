# Defined in - @ line 2
function eispdf --wraps=pandoc --description 'Converts pandoc file formats to PDF using eisvogel template'
    set author 'Khaveesh N'
    pandoc --pdf-engine=lualatex --template=eisvogel --listings -C --csl=ieee -M link-citations $argv[1] -o $argv[2] -V lang=en-GB -V csquotes -V title="$argv[3]" -V title-meta="$argv[3]" -V author="$author" -V author-meta="$author" $argv[4..]
end
