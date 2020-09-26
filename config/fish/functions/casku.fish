# Defined in - @ line 1
function casku --wraps='cask upgrade' --wraps='brew upgrade --cask' --description 'alias casku brew upgrade --cask'
  brew upgrade --cask $argv;
end
