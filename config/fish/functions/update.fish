# Defined in - @ line 1
function update --description 'alias update sudo softwareupdate -i -a; brew upgrade; pipu; tlmgru'
    sudo softwareupdate -i -a
    echo
    brew upgrade
    echo
    pipu
    echo
    tlmgr update --all --self
end
