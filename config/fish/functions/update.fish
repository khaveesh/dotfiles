# Defined in - @ line 1
function update --description 'alias update sudo softwareupdate -i -a; brew upgrade; pipu; tlmgr update --all --self'
    sudo softwareupdate --all --install --verbose
    echo
    brew upgrade
    echo
    pipu
    echo
    tlmgr update --all --self
    echo
    ~/.config/nvim/nvim_packer.py
end
