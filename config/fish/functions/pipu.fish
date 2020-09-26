# Defined in - @ line 1
function pipu --wraps='pip list --outdated --format=freeze | grep -v ^-e | cut -d = -f 1  | xargs -n1 pip install -U' --description 'alias pipu pip list --outdated --format=freeze | grep -v ^-e | cut -d = -f 1  | xargs -n1 pip install -U'
    pip list --outdated --format=freeze | grep -v ^-e | cut -d = -f 1 | xargs -n1 pip install --use-feature=2020-resolver -U
end
