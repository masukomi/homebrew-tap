class Cleandiff < Formula
  desc "A graphical diffing tool that's easy on your brain"
  homepage "https://github.com/masukomi/cleandiff"
  version "1.0.0"
  url "https://github.com/masukomi/cleandiff/archive/refs/tags/v#{version}.tar.gz"
  sha256 "487196b10e24686d50335c8ffe1e8e627a0ef669d40acc2c6b71fe4da5998606"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # Install wails CLI
    system "go", "install", "github.com/wailsapp/wails/v2/cmd/wails@latest"
    wails = "#{ENV["GOPATH"]}/bin/wails"

    # Install frontend dependencies
    cd "frontend" do
      system "npm", "install"
    end

    on_macos do
      # Build macOS app bundle
      system wails, "build", "-platform", "darwin/universal"

      # Install the .app bundle to the prefix
      prefix.install "build/bin/cdiff.app" => "CleanDiff.app"

      # Symlink the CLI executable to bin
      bin.install_symlink prefix/"CleanDiff.app/Contents/MacOS/cdiff"
    end

    on_linux do
      # Build Linux binary
      system wails, "build", "-platform", "linux/amd64"

      # Install the binary directly to bin
      bin.install "build/bin/cdiff"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        CleanDiff.app has been installed to:
          #{prefix}/CleanDiff.app

        You can add it to your Applications folder with:
          ln -s #{prefix}/CleanDiff.app /Applications/CleanDiff.app

        The CLI tool 'cdiff' has been added to your PATH.
      EOS
    end
  end

  test do
    # Verify the CLI executable exists and runs
    assert_predicate bin/"cdiff", :exist?
  end
end
