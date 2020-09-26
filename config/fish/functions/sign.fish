# Defined in - @ line 1
function sign --wraps=codesign --description='Replaces existing code signature with user generated sign'
    sudo codesign --force --deep --sign - $argv && sudo codesign -dvvvv $argv && sudo codesign --verify -vv $argv
end
