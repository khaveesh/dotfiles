function fish_user_key_bindings
    bind \e, 'commandline -ij "( | psub)"; commandline -f backward-word backward-word backward-word'
    bind \ek kill-whole-line
end
