class Minecli < Formula
  desc "A beautiful TUI (Terminal User Interface) client for Redmine project management"
  homepage "https://github.com/ecugol/minecli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-aarch64-apple-darwin.tar.xz"
      sha256 "7020b7c279a781aef1b67039ae267c11bde473da9eb92a219fd30d02845bc62a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-x86_64-apple-darwin.tar.xz"
      sha256 "9e2fd97fd61a8865b8eb5781426d392b22769ff730c8985b68f24236a8d8ca4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1d49698dcf162754f0a6f265c2f98ba3f1d87b27857cc075ef14a059cb279a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "58a9d35ec77b440661f289b3b80e256dbe01dc9cccaa3a4b4a74a63ebe932c50"
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
