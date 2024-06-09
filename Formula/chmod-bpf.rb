class ChmodBpf < Formula
  desc "Managing BPF device permissions on macOS"
  homepage "https://github.com/shellrow/chmod-bpf"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.3.0/chmod-bpf-aarch64-apple-darwin.tar.xz"
      sha256 "5bd252f9072fad307610c04a21845b5c169ed700e1dd770be158a2f71154668f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/shellrow/chmod-bpf/releases/download/v0.3.0/chmod-bpf-x86_64-apple-darwin.tar.xz"
      sha256 "7e541a254c78c7433fe696815bf21de27f80803bc2e4ee555e595517a1beaeb2"
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
