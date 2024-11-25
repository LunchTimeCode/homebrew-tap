class Hay < Formula
  desc "A tool to check if all is healthy"
  homepage "https://github.com/LunchTimeCode/hay"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.3/hay-aarch64-apple-darwin.tar.gz"
      sha256 "ad35f2cb9bc78e4f65960cf3ef3807f7b4a15be7063132a8246aa35dc781ca78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.3/hay-x86_64-apple-darwin.tar.gz"
      sha256 "19fc02cf919dfc33ba45f419bea14124f135064a5b5a97f60502e8cfdbd35e06"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.3/hay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3b9612b170bbd9062b152e8e0d1d86426f7aebd57dcaba564650bdcbfcb56dfe"
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
