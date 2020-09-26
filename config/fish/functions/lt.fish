# Defined in - @ line 1
function lt --wraps='exa --tree --level=2' --description 'alias lt exa --tree --level=2'
    exa -T --group-directories-first $argv
end
