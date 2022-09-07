# Defined in - @ line 1
function ql --wraps=qlmanage --description 'QuickLook from Terminal'
    qlmanage -p $argv[1] &>/dev/null && open -a kitty
end
