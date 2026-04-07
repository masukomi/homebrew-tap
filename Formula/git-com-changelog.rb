class GitComChangelog < Formula
  desc "A changelog generator that utilizes structured commits created by git-com "
  homepage "https://github.com/masukomi/git-com-changelog"
  current_version="1.0.0"
  url "https://github.com/masukomi/git-com-changelog/archive/refs/tags/v#{current_version}.tar.gz"
  sha256 "2ac53cb35dab43404f8735a86b37d62b56a4e2a7b22bf6200eb23828e81d9e9e"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"git-com-changelog"), "."
  end

  test do
    # Running without a .git-com.yaml should show usage/error
    assert_match "error", shell_output("#{bin}/git-com-changelog 2>&1", 1).downcase
  end
end
