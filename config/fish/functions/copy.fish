# Defined in - @ line 1
function copy --wraps='pbcopy <' --description 'alias copy pbcopy <'
    pbcopy <$argv[1]
end
