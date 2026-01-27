class AudiobookCreator < Formula
  desc "Create m4b audiobook files from a folder of audio files"
  homepage "https://github.com/masukomi/audiobook_creator"
  current_version="1.0.0"
  url "https://github.com/masukomi/audiobook_creator/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "8bed0e403946c3b628eb6779ee271f06b3c221ea5823b1b1f32aaab125be11d2"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"audiobook_creator"), "."
  end

  test do
    # Running without arguments should show usage/error
    assert_match "error", shell_output("#{bin}/audiobook_creator 2>&1", 1).downcase
  end
end
