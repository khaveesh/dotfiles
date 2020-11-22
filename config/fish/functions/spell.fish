# Defined in - @ line 1
function spell --description 'Spell checks common file formats supported by pandoc'
    pandoc --lua-filter spellcheck.lua $argv[1] | sort | uniq
    pandoc $argv[1] -t markdown -o /tmp/pandoc.md
    vale /tmp/pandoc.md
end
