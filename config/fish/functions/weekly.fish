# Defined in - @ line 1
function weekly --description 'Run weekly updates'
    curl https://raw.githubusercontent.com/ookangzheng/dbl-oisd-nl/master/hosts_light.txt >/etc/hosts
    echo
    cp ~/dotfiles/neovim.rb /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/
    brew reinstall --no-quarantine --cask neovim
    rm /usr/local/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/neovim.rb
    echo
    ~/.config/nvim/nvim_packer.py
end
