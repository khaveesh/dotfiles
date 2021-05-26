# Defined in - @ line 2
function ieeepdf --wraps=pandoc --description 'Converts pandoc file formats to IEEE-style PDF'
    set author 'Khaveesh N'
    pandoc --pdf-engine=lualatex --template=ieee -V documentclass=IEEEtran -N -C --csl=ieee -M link-citations $argv[1] -o $argv[2] -V mainfont='STIX Two Text' -V monofont='SF Mono' -V fontsize=9pt -V indent -V csquotes -V urlcolor=[HTML]{0063D7} -V title="$argv[3]" -V title-meta="$argv[3]" -V author=$author -V author-meta=$author $argv[4..]
end
