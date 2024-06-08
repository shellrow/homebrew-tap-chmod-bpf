class ChmodBpf < Formula
  desc "Managing BPF device permissions on macOS"
  homepage "https://github.com/shellrow/chmod-bpf"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.2.0/chmod-bpf-aarch64-apple-darwin.tar.xz"
      sha256 "3361af2659e53b7cefce0a2e75242847d5adce55b1def03eaab78346f715b7c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.2.0/chmod-bpf-x86_64-apple-darwin.tar.xz"
      sha256 "ddf01fb5461c3a32eb5ca284c4e686cbd0aa78387e6ae692be93a76625a25f00"
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
