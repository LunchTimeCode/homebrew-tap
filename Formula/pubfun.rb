class Pubfun < Formula
  desc "A tool to extract public functions from Kotlin files."
  homepage "https://github.com/LunchTimeCode/pubfun"
  version "0.1.3"
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/pubfun/releases/download/v0.1.3/pubfun-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df98e9ed0dd07e1c8ab0b3d352ff171b4b6016009888af07beff56888ad53d1d"
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
