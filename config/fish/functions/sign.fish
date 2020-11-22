# Defined in - @ line 1
function sign --wraps=codesign --description 'Replaces existing code signature with user generated sign'
    sudo codesign --force --deep --sign - $argv[1] && sudo codesign -dvvvv $argv[1] && sudo codesign --verify -vv $argv[1]
end
