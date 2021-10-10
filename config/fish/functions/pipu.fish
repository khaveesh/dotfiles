# Defined via `source`
function pipu --wraps='pip install -U' --description 'Upgrades outdated pip packages'
    pip install -U \
        black \
        doq \
        isort \
        jedi-language-server \
        mypy \
        pandocfilters \
        pip \
        pylint \
        pyyaml \
        requests \
        wemake-python-styleguide
end
