class GitCom < Formula
  desc "CLI tool that creates consistent git commit messages through YAML-configured interactive prompts"
  homepage "https://github.com/masukomi/git-com"
  current_version="1.3.0"
  url "https://github.com/masukomi/git-com/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "f64d78af0466ea31dbfea7ed1eccfddde0d32375ffc51119e2cf065ff4b59a95"
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
