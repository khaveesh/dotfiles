cask "neovim" do
  version "nightly"
  sha256 :no_check

  url "https://github.com/neovim/neovim/releases/download/#{version}/nvim-macos.tar.gz",
      verified: "github.com/neovim/neovim/"
  appcast "https://github.com/neovim/neovim/releases.atom"
  name "Neovim Cask"
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"

  conflicts_with formula: "neovim"

  binary "nvim-osx64/bin/nvim"
end
