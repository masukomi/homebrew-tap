class GitCom < Formula
  desc "CLI tool that creates consistent git commit messages through YAML-configured interactive prompts"
  homepage "https://github.com/masukomi/git-com"
  current_version="1.6.0"
  url "https://github.com/masukomi/git-com/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "15bc095b654b7f2291099e1ec31de74d1b6660b15ad6b542c77b44ea73fe8134"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"git-com"), "."
  end

  test do
    # Running without a .git-com.yaml should show usage/error
    assert_match "error", shell_output("#{bin}/git-com 2>&1", 1).downcase
  end
end
