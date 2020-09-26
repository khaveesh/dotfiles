# Defined in - @ line 1
function update --description 'alias update sudo softwareupdate -i -a; brewu; pipu; tlmgru'
    sudo softwareupdate -i -a
    brewu
    pipu
    tlmgr update --all --self
end
