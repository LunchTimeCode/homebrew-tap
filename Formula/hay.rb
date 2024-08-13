class Hay < Formula
  desc "A tool to check if all is healthy"
  homepage "https://github.com/LunchTimeCode/hay"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.2.0/hay-aarch64-apple-darwin.tar.gz"
      sha256 "f14a8dbd127ab7b6b991cc4da77543d65cf2f5a6c973efdf3473944e6d5af8ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.2.0/hay-x86_64-apple-darwin.tar.gz"
      sha256 "3a4f055e47c1fa7d9f03c7034971e99b3a7f5520b5ea1c55d3193a8fbd2c13a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.2.0/hay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "de571e22f5ba0a86f37fa043a35bdf27225f3e47a84307e3773ea902cb0c5e6b"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hy"
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
