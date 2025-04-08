class Pubfun < Formula
  desc "A tool to extract public functions from Kotlin files."
  homepage "https://github.com/LunchTimeCode/pubfun"
  version "0.1.2"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/pubfun/releases/download/v0.1.2/pubfun-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c59c1d3eceb2b6f0a403cca3d4a82fd975cedb0e5aaef2be2b2c34fad1aa72a3"
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
      bin.install "pubfun"
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
