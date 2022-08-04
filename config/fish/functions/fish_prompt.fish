function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    # PWD
    # echo
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    echo -n ' '
    fish_git_prompt "%s "

    echo -n (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)

    if test $__fish_last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n "❯ "
    set_color normal
end
