# Defined in - @ line 1
function pipu --wraps='pip install -U' --description 'Upgrade outdated pip packages'
    pip install -U \
        black \
        doq \
        jedi-language-server \
        mypy \
        pip \
        pylint \
        requests \
        ruff \
        ruff-lsp
end
