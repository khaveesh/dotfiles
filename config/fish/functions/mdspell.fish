# Defined in - @ line 1
function mdspell --wraps='pandoc --lua-filter spellcheck.lua' --description 'alias mdspell pandoc --lua-filter spellcheck.lua'
    # pandoc --lua-filter spellcheck.lua $argv | sort | uniq
    codespell $argv
    vale $argv
end
