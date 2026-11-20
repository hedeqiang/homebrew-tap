# Homebrew cask for the Crewbase desktop app (macOS, universal).
# The release workflow fills in 0.9.3 and 3fd41df57fed1ed31f2c005f33d592c126d0e3f57c0373a8902d610f4a10db66 and pushes the result
# to the hedeqiang/homebrew-tap repository as Casks/crewbase.rb.
cask "crewbase" do
  version "0.9.3"
  sha256 "3fd41df57fed1ed31f2c005f33d592c126d0e3f57c0373a8902d610f4a10db66"

  url "https://github.com/hedeqiang/crewbase/releases/download/v#{version}/crewbase-#{version}.dmg"
  name "Crewbase"
  desc "Local-first workspace for a team of AI agents"
  homepage "https://github.com/hedeqiang/crewbase"

  livecheck do
    url :url
    strategy :github_latest
  end

  # the app updates itself (Settings › General › Updates)
  auto_updates true
  depends_on macos: :monterey

  app "Crewbase.app"

  # The app is not notarized yet (no Developer ID): without this, macOS
  # refuses to open a download it cannot verify.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Crewbase.app"],
        writable_paths: ["{{appdir}}/Crewbase.app"]
  end

  uninstall quit: "app.crewbase.desktop"

  # Agents, conversations and settings live in ~/.crewbase and are kept;
  # remove that folder by hand to delete them too.
  zap trash: [
    "~/Library/Preferences/app.crewbase.desktop.plist",
    "~/Library/Saved Application State/app.crewbase.desktop.savedState",
  ]
end
