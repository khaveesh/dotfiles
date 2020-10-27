# Defined in - @ line 1
function brewu --wraps='brew update && brew upgrade && casku && brew cleanup -s' --description 'alias brewu brew update && brew upgrade && casku && brew cleanup -s'
    brew update && brew upgrade && casku && brew cleanup -s
end
