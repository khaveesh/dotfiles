# Defined in - @ line 2
function eispdf --wraps=pandoc --description 'Converts pandoc file formats to pdf with eisvogel template'
    spell $argv[1]
    set author 'Khaveesh N'
    pandoc -s --listings --template=eisvogel --pdf-engine=lualatex -V author="$author" -V author-meta="$author" -V lang=en-GB $argv[1] -o $argv[2] $argv[3..-1]
end
