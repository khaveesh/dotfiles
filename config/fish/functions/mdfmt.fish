# Defined in - @ line 1
function mdfmt --wraps='pandoc -t markdown -s --atx-headers --columns=80' --description 'alias mdfmt pandoc -t markdown -s --atx-headers --columns=80'
    if set -q argv[1]
        pandoc -f markdown -t markdown-inline_code_attributes-fenced_code_attributes -s --atx-headers --columns=80 $argv[1] -o $argv[1]
    else
        pandoc -f markdown -t markdown-inline_code_attributes-fenced_code_attributes -s --atx-headers --columns=80
    end
end
