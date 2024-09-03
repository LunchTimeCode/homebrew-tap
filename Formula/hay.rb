class Hay < Formula
  desc "A tool to check if all is healthy"
  homepage "https://github.com/LunchTimeCode/hay"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.2/hay-aarch64-apple-darwin.tar.gz"
      sha256 "041107b5d90df129df955180f18f4d965920b7601d63b3e846281dee7f4849af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.2/hay-x86_64-apple-darwin.tar.gz"
      sha256 "8abab9d7c907d448952b54dc7a49f63fa7ad95b48370e28f0ba8cf25979ff65f"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.2/hay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fcf14cb5bdc2a269b58efe0d759bed387c6a684b4ffd3e27855b4b898c6db0f"
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
