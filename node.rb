cask "node" do
  version "16.0.0"
  sha256 :no_check

  url "https://nodejs.org/dist/v#{version}/node-v#{version}-darwin-x64.tar.gz"
  name "Node Cask"
  desc "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine"
  homepage "https://nodejs.org/"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  conflicts_with formula: "node"

  binary "node-v#{version}-darwin-x64/bin/node"
  manpage "node-v#{version}-darwin-x64/share/man/man1/node.1"
end
