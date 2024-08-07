class ChmodBpf < Formula
  desc "Managing BPF device permissions on macOS"
  homepage "https://github.com/shellrow/chmod-bpf"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.4.0/chmod-bpf-aarch64-apple-darwin.tar.xz"
      sha256 "3743166e2ee287676688ac03ab585a5af004c10bb783994831233a64eb3cc52e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.4.0/chmod-bpf-x86_64-apple-darwin.tar.xz"
      sha256 "f14f16ab6e1b53917e293c9e1fa0d0cfd31f09b294863b589e9bb1561e101ee5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}}

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
      bin.install "chmod-bpf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "chmod-bpf"
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
