# Defined in - @ line 2
function ql --wraps='qlmanage -p &>/dev/null' --description 'alias ql qlmanage -p &>/dev/null'
    qlmanage -p $argv &>/dev/null
end
