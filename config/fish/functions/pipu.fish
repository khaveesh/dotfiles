# Defined via `source`
function pipu --wraps='pip install -U' --description 'Upgrade outdated pip packages'
    pip install -U \
        black \
        doq \
        isort \
        jedi-language-server \
        mypy \
        pip \
        pylint \
        requests \
        wemake-python-styleguide
end
