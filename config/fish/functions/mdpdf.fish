# Defined in - @ line 2
function mdpdf --wraps=pandoc --description 'Converts markdown to pdf'
    mdspell $argv[1]
    set author 'Khaveesh N'
    pandoc -f markdown -s --listings --template=eisvogel --pdf-engine=lualatex -V author="$author" -V author-meta="$author" -V lang=en-GB $argv[1] -o $argv[2] $argv[3..-1]
end
