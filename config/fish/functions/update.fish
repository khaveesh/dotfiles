# Defined in - @ line 1
function update --description 'alias update brew upgrade; pipu; tlmgr update --all --self'
    brew upgrade
    echo
    pipu
    echo
    tlmgr update --all --self
    echo
    ~/.config/nvim/nvim_packer.py
end
