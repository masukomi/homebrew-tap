class GitCom < Formula
  desc "CLI tool that creates consistent git commit messages through YAML-configured interactive prompts"
  homepage "https://github.com/masukomi/git-com"
  current_version="1.4.1"
  url "https://github.com/masukomi/git-com/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "f255c56f8cac55b2be960528f50d8838df382505e54244e86de190bcf81b2418"
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
