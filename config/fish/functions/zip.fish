# Defined in - @ line 1
function zip --wraps='zip -x "*.DS_Store" -r' --description 'alias zip zip -x "*.DS_Store" -r'
    command zip -x "*.DS_Store" -r $argv
end
