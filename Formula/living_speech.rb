class LivingSpeech < Formula
  desc "Menu bar text-to-speech app for people who can't talk"
  homepage "https://github.com/masukomi/living_speech"
  version "1.0.0"
  url "https://github.com/masukomi/living_speech/archive/refs/tags/v#{version}.tar.gz"
  sha256 "bc9800296d5bb93c42b7d31d9fffd6f5d9b81467805b95221208c8af9638b6f2"
  license "GPL-3.0-or-later"

  depends_on "go" => :build
  depends_on "node" => :build
  # Opening at login uses SMAppService, which needs macOS 13 (Ventura).
  depends_on macos: :ventura

  def install
    # Install the Wails CLI at the same version as the project's go.mod, so the
    # CLI's code generators match the Wails runtime the app is built against.
    wails_version = File.read("go.mod")[%r{github\.com/wailsapp/wails/v3 (\S+)}, 1]
    ENV["GOBIN"] = buildpath/"tools"
    system "go", "install", "github.com/wailsapp/wails/v3/cmd/wails3@#{wails_version}"
    # The build's Taskfile runs wails3 itself, so it has to be on the PATH.
    ENV.prepend_path "PATH", buildpath/"tools"

    # Installs the frontend's npm packages, builds the frontend and the Go
    # binary for this Mac's architecture, and assembles bin/LivingSpeech.app.
    system "wails3", "package"

    prefix.install "bin/LivingSpeech.app"
  end

  def caveats
    <<~EOS
      LivingSpeech.app was installed to:
        #{opt_prefix}/LivingSpeech.app

      To add it to your Applications folder:
        ln -sf "#{opt_prefix}/LivingSpeech.app" /Applications/LivingSpeech.app
    EOS
  end

  test do
    app = prefix/"LivingSpeech.app"
    executable = app/"Contents/MacOS/livingspeech"

    # The bundle is complete and correctly identified.
    assert_predicate executable, :executable?
    assert_path_exists app/"Contents/Resources/icons.icns"
    plist = app/"Contents/Info.plist"
    assert_equal "org.masukomi.livingspeech",
                 shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' #{plist}").strip

    # The ad-hoc signature is intact, so macOS will launch it.
    system "codesign", "--verify", "--deep", app

    # The app actually runs: it loads its system frameworks and reads its
    # version from the bundle, then exits without opening any windows.
    assert_equal "LivingSpeech #{version}", shell_output("#{executable} --version").strip
  end
end
