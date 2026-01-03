class GitCom < Formula
  desc "CLI tool that creates consistent git commit messages through YAML-configured interactive prompts"
  homepage "https://github.com/masukomi/git-com"
  current_version="1.2.1"
  url "https://github.com/masukomi/git-com/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "31b4d516fb2ff5c741458daf175889a3713abde8f6213a4bbab024fdc9632db5"
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
