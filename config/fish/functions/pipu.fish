# Defined via `source`
function pipu --wraps='pip install -U' --description 'Upgrades outdated pip packages'
    pip install -U \
        black \
        doq \
        isort \
        ipython \
        jedi-language-server \
        jupyterlab \
        matplotlib \
        mypy \
        numpy \
        pandocfilters \
        pip \
        pylint \
        pyyaml \
        requests \
        wemake-python-styleguide
end
