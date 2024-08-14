class Hay < Formula
  desc "A tool to check if all is healthy"
  homepage "https://github.com/LunchTimeCode/hay"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.0/hay-aarch64-apple-darwin.tar.gz"
      sha256 "4a35692ee3064fdcbf76005f96c490a2cd038d3f57b3ef0ae7cf1a54bdd87758"
    end
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.0/hay-x86_64-apple-darwin.tar.gz"
      sha256 "d30e9e6baeff357e3864056e897eebd337487b9038eaac9359c46be3afc15fdd"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/LunchTimeCode/hay/releases/download/v0.3.0/hay-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a58501fe2d5ce55e374c8363d8471d01afcdaadbb89443ff5ab0f401cd85cf69"
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
