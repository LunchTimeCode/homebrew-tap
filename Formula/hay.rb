class Hay < Formula
  desc "A tool to check if all is healthy"
  homepage "https://github.com/LunchTimeCode/hay"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.1.0/hay-aarch64-apple-darwin.tar.gz"
      sha256 "0a2247da3e6e376b4f77eb3654f07f23fd6b70a6ac175ef3e650ded2397c5b40"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.1.0/hay-x86_64-apple-darwin.tar.gz"
      sha256 "399dadbc8f1c9d8bbf75b6e090dcde990115f7932da1f30822f8784473471bc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.1.0/hay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0486b7c4185945e3f7d6ff528c546afc69be1d41f5028fce335aadf0951995d5"
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
