# Defined in - @ line 1
function brewu --wraps='brew update && brew upgrade && casku && brew cleanup' --description 'alias brewu brew update && brew upgrade && casku && brew cleanup'
    brew update && brew upgrade && casku && brew cleanup
end
