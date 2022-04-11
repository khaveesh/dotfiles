# Defined in - @ line 1
function ieeepdf --wraps=pandoc --description 'Convert pandoc file formats to IEEE-style PDF'
    set author 'Khaveesh N'
    pandoc -L refnos.lua --pdf-engine=latexmk --pdf-engine-opt='-lualatex' --pdf-engine-opt='-outdir=/tmp/pandoc' --template=ieee -N -C --csl=ieee -M link-citations $argv[1] -o $argv[2] -V documentclass=IEEEtran -V mainfont='STIX Two Text' -V mathfont='STIX Two Math' -V fontsize=9pt -V lang=en-GB -V csquotes -V urlcolor=[HTML]{0063D7} -V title="$argv[3]" -V title-meta="$argv[3]" -V author=$author -V author-meta=$author $argv[4..]
end
