# Defined in - @ line 1
function nodeu --description 'Update node'
    cp ~/dotfiles/node.rb /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/ \
        && brew upgrade --cask node \
        && rm /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/node.rb
end
