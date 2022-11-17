function fish_user_key_bindings
    bind \e, 'commandline -i "( | psub)"; commandline -C (math (commandline -C) - 8)'
    bind \ek kill-whole-line
    bind \b backward-kill-bigword
end
