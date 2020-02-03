module Macos
  module SystemPreferences
    def self.docker
      puts '⚙️ config docker...'

      puts '  - adjust size'
      system 'defaults write com.apple.dock tilesize -int 20'
      system 'defaults write com.apple.dock largesize -int 40'

      puts '  - Make Dock icons of hidden applications translucent'
      system 'defaults write com.apple.dock showhidden -bool true'
    end

    def self.finder
      puts '⚙️ config finder...'

      puts '  - Show file extensions'
      system 'defaults write -g AppleShowAllExtensions -bool true'

      puts '  - Show hidden files'
      system 'defaults write com.apple.finder AppleShowAllFiles true'

      puts '  - Do not hide ~/Library'
      system 'chflags nohidden ~/Library'

      puts '  - Show status bar'
      system 'defaults write com.apple.finder ShowStatusBar -bool true'

      puts '  - Show path bar'
      system 'defaults write com.apple.finder ShowPathbar -bool true'

      puts '  - Search current folder by default'
      system 'defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"'

      puts '  - Disable the warning when changing a file extension'
      system 'defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false'

      puts '  - Avoid creating .DS_Store files on network and USB volumes'
      system 'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'
      system 'defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true'

      puts '  - Use list view in all Finder windows by default'
      system 'defaults write com.apple.Finder FXPreferredViewStyle "Nlsv"'

      puts '  - keep folders on top'
      system 'defaults write com.apple.finder _FXSortFoldersFirst -bool true'

      puts '  - Enable AirDrop over Ethernet and on unsupported Macs running Lion'
      system 'defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true'

      puts '  - Set $HOME as the default location for new Finder windows'
      system 'defaults write com.apple.finder NewWindowTarget -string "PfLo"'
      system 'defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"'

      puts '  - Show HD icons on desktop'
      system 'defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true'
      system 'defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true'
      system 'defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true'

      puts '  - Show full path'
      system 'defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES'
    end

    def self.keyboard
      puts '⚙️ config keyboard...'

      puts '  - Disable auto-correct'
      system 'defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false'

      puts '  - Enable key-repeat'
      system 'defaults write -g ApplePressAndHoldEnabled -bool false'

      puts '  - Make key repeat lighting fast'
      system 'defaults write NSGlobalDomain InitialKeyRepeat -int 12'
      system 'defaults write -g KeyRepeat -int 1'

      puts '  - Disable automatic capitalization'
      system 'defaults write -g NSAutomaticCapitalizationEnabled -bool false'

      puts '  - Enable full keyboard access for all controls'
      system 'defaults write NSGlobalDomain AppleKeyboardUIMode -int 3'

      puts '  - Disable automatic period substitution'
      system 'defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false'

      puts '  - Disable smart dashes'
      system 'defaults write -g NSAutomaticDashSubstitutionEnabled -bool false'

      puts '  - Disable smart quotes'
      system 'defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false'
    end

    def self.trackpad
      puts '⚙️ config trackpad...'

      puts '  - Enable tap to click'
      system 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true'
      system 'defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'
      system 'defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'
    end

    def self.system_config
      puts '⚙️ config system...'

      puts '  - Use hibernatemode 0'
      system 'sudo pmset -a hibernatemode 0'

      puts '  - Prevent from prompting to use new hard drives as backup volume'
      system 'defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true'
    end

    def self.restart_apps
      ['cfprefsd', 'Dock', 'Finder', 'Safari', 'SystemUIServer'].each do |app|
        system %(killall "#{app}" > /dev/null 2>&1 || true)
      end
    end
  end
end
