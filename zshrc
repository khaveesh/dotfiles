# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# =============================================================================
# Changing Directories
# =============================================================================

# If a command is issued that can't be executed as a normal command, and the
# command is the name of a directory, perform the cd command to that directory.
setopt auto_cd

# Make cd push the old directory onto the directory stack.
setopt auto_pushd

# Don't push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# =============================================================================
# History
# =============================================================================

# If the internal history needs to be trimmed to add the current command line,
# setting this option will cause the oldest history event that has a duplicate
# to be lost before losing a unique event from the list.
setopt hist_expire_dups_first

# When searching for history entries in the line editor, do not display
# duplicates of a line previously found, even if the duplicates are not
# contiguous.
setopt hist_find_no_dups

# Do not enter command lines into the history list if they are duplicates of the
# previous event.
setopt hist_ignore_dups

# Whenever the user enters a line with history expansion, don't execute the line
# directly; instead, perform history expansion and reload the line into the
# editing buffer.
setopt hist_verify

# This options works like APPEND_HISTORY except that new history lines are added
# to the $HISTFILE incrementally (as soon as they are entered), rather than
# waiting until the shell exits.
setopt inc_append_history

bindkey -e
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
elif [[ $BUFFER == $EDITOR\ * ]]; then
    LBUFFER="${LBUFFER#$EDITOR }"
    LBUFFER="sudoedit $LBUFFER"
elif [[ $BUFFER == sudoedit\ * ]]; then
    LBUFFER="${LBUFFER#sudoedit }"
    LBUFFER="$EDITOR $LBUFFER"
else
    LBUFFER="sudo $LBUFFER"
fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\es" sudo-command-line

_dircycle_update_cycled() {
    setopt localoptions nopushdminus

    [[ ${#dirstack} -eq 0 ]] && return 1

    while ! builtin pushd -q $1 &>/dev/null; do
        # A missing directory was found; pop it out of the directory stack.
        builtin popd -q $1

        # Stop trying if there are no more directories in the directory stack.
        [[ ${#dirstack} -eq 0 ]] && return 1
    done

    # Trigger a prompt update if using Pure (https://github.com/sindresorhus/pure).
    local fn
    for fn (chpwd $chpwd_functions precmd $precmd_functions); do
        (( $+functions[$fn] )) && $fn
    done
    zle reset-prompt
}

_dircycle_insert_cycled_left() {
    _dircycle_update_cycled +1 || return
}

zle -N _dircycle_insert_cycled_left

_dircycle_insert_cycled_right() {
    _dircycle_update_cycled -0 || return
}

zle -N _dircycle_insert_cycled_right

# Bind Ctrl + Shift + Left key combination to backwards direction.
bindkey "\eb" _dircycle_insert_cycled_left

# Bind Ctrl + Shift + Right key combination to forwards direction.
bindkey "\ef" _dircycle_insert_cycled_right

bindkey "\e[1;3D" backward-word
bindkey "\e[1;3C" forward-word

export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zplug "marlonrichert/zsh-autocomplete"
zplug "Aloxaf/fzf-tab"
zplug "zdharma/fast-syntax-highlighting"
zplug "MichaelAquilina/zsh-auto-notify"
zplug "hlissner/zsh-autopair", defer:2
zplug "arzzen/calc.plugin.zsh"
zplug "qoomon/zjump"
zplug romkatv/powerlevel10k, as:theme, depth:1
# zplug install
zplug load
export AUTO_NOTIFY_THRESHOLD=0.5

source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias vim="nvim"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
