# Defined in - @ line 1
function iosevka --description 'Builds the latest Iosevka version with custom build plan'
    cd ~/Developer/Iosevka \
        && set tag (curl -s https://api.github.com/repos/be5invis/Iosevka/releases/latest | awk -F '"' '/tag_name/{print $4}') \
        && curl -sL "https://github.com/be5invis/Iosevka/archive/$tag.tar.gz" | tar xf - --strip-components=1 \
        && npm install && cp ~/private-dotfiles/private-build-plans.toml . && npm run build -- ttf-unhinted::iosevka-custom \
        && cp dist/iosevka-custom/ttf-unhinted/* ~/Library/Fonts/ \
        && cd ..
end
