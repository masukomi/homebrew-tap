class Oho < Formula
  desc "Takes your colorful terminal output and converts it to HTML for sharing"
  homepage "https://github.com/masukomi/oho"
  current_version="1.3.8"
  url "https://github.com/masukomi/oho/archive/refs/tags/v#{current_version}.tar.gz"
  # url "https://github.com/masukomi/oho/releases/download/#{current_version}/oho_#{current_version}-src.tgz"
  # url "file:///Users/masukomi/workspace/oho/oho_#{current_version}-src.tgz"
  sha256 "4476c8b6a676e5f16d84ca4ff2fc0af1d4781d7600e711b388558008cf70d4b4"

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libev"
  depends_on "libevent"
  depends_on "llvm"
  depends_on "pcre"

  def install
    system "crystal", "build", "--release", "src/oho.cr"
    bin.install "oho"
  end

  test do
    out = pipe_output(bin/"oho", "[35mno[34mfascism[00m")
    style_regexp = %r{<span style="color: fuchsia; ">no</span><span style="color: #3333FF; ">fascism</span>}
    assert_match(style_regexp, out)
  end
end
