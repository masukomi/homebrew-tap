class GitCom < Formula
  desc "CLI tool that creates consistent git commit messages through YAML-configured interactive prompts"
  homepage "https://github.com/masukomi/git-com"
  current_version="v1.7.0"
  url "https://github.com/masukomi/git-com/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "08190e25b0bf037f2e74e27abd9430cc1230878b16cc43d875f6b0c45533540a"
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
