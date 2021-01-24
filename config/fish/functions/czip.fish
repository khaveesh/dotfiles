# Defined in - @ line 1
function czip --wraps='zip -x "*.DS_Store" -r' --description 'alias czip zip -x "*.DS_Store" -r'
    command zip -x "*.DS_Store" -r $argv
end
