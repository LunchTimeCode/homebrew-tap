class Amisane < Formula
  desc "A simple and fast CLI tool to check csv files"
  homepage "https://github.com/LunchTimeCode/amisane"
  version "0.2.0"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/amisane/releases/download/v0.2.0/amisane-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3a1bf545ae1d65c6a0e0ce514a955655258dcead7a1700e2bffa92c1079f649"
    end
  end

  BINARY_ALIASES = {"x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.linux? && Hardware::CPU.intel?
      bin.install "amisane"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
