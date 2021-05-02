# Defined in - @ line 1
function ql --description QuickLook
    qlmanage -p $argv[1] &>/dev/null && open -a kitty
end
