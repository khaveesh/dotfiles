# Defined in - @ line 1
function pipu --description 'Upgrades outdated pip packages'
    pip list --outdated --format=freeze | grep -v ^-e | cut -d = -f 1 | xargs -n1 pip install -U
end
