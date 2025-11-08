class Minecli < Formula
  desc "A beautiful TUI (Terminal User Interface) client for Redmine project management"
  homepage "https://github.com/ecugol/minecli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.1/minecli-aarch64-apple-darwin.tar.xz"
      sha256 "89db4c0573c2f5e3a0a7b7735ab5b9e91a5698e6fb499e6319b903528c1a4a19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.1/minecli-x86_64-apple-darwin.tar.xz"
      sha256 "3979e63b168783a2798df040027295a594a93916bfde8eadbd072d4a80bd15a1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.1/minecli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5f77b79fb25f479aa7dcd42e186aba755a7395888ffb62f6a44113684a7fdb9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.1/minecli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29800fbd2d8294e570cb135c9071ad6ef1eb17daf2252490b177093ec422c95a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "minecli" if OS.mac? && Hardware::CPU.arm?
    bin.install "minecli" if OS.mac? && Hardware::CPU.intel?
    bin.install "minecli" if OS.linux? && Hardware::CPU.arm?
    bin.install "minecli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
