class Minecli < Formula
  desc "A beautiful TUI (Terminal User Interface) client for Redmine project management"
  homepage "https://github.com/ecugol/minecli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-aarch64-apple-darwin.tar.xz"
      sha256 "ee989d071980be374a0ec3e682ac9a83dc32fbce7de2c7adc49b866267313e22"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-x86_64-apple-darwin.tar.xz"
      sha256 "843e398d864185866d0a7dc2ffe39ae0a7d7dc9666277f268145bc0e24aaea65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "84d623bcd13dcc5df55b2e4426ac062cfd2f12ba44d14d04d2807d9ceaaee7d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ecugol/minecli/releases/download/v0.1.0/minecli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e7c6fd77b6cee802364e2515df3ce9af72f9564b94cbdc1297fc3ff47c5baba"
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
