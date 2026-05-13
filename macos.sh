#!/bin/zsh

# close any system preference windows first
osascript -e 'tell application "System Preferences" to quit'

# become root
sudo -v

# stay root
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

####################################
# System

# Always show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Disable system sounds
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Enable Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Enable Firewall stealth mode (don't respond to pings or connection probes)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Disable AirDrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool true

# Disable Handoff
defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool false

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Disable crash reporter dialog
defaults write com.apple.CrashReporter DialogType -string "none"

# Remind to enable FileVault (can't be automated silently)
if ! fdesetup status | grep -q "On"; then
  echo "⚠️  FileVault is OFF. Enable it in System Settings > Privacy & Security > FileVault"
fi

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "US"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Custom DateFormat
defaults write com.apple.menuextra.clock DateFormat "yyyy-MM-dd HH:mm:ss EEEEEE"

####################################
# Trackpad, keyboard

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Non-breaking spaces: https://superuser.com/questions/78245/how-to-disable-the-option-space-key-combination-for-non-breaking-spaces
mkdir -p ~/Library/KeyBindings
cat > ~/Library/KeyBindings/DefaultKeyBinding.dict <<EOF
{
"~ " = ("insertText:", " ");
}
EOF

####################################
# Screen

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

####################################
# Finder

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show hidden files by default
#defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

# Screenshot location
test -d "${HOME}/Pictures/Screenshots" || mkdir -p "${HOME}/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Pictures/Screenshots"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

####################################
# Safari & WebKit

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Hide Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool false
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

####################################
# Terminal

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

####################################
# Activity Monitor

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

####################################
# Photos

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

####################################
# Messages

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

####################################
# Google Chrome

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true

# Privacy: block third-party cookies
defaults write com.google.Chrome BlockThirdPartyCookies -bool true

# Privacy: disable search suggestions sent to Google
defaults write com.google.Chrome SearchSuggestEnabled -bool false

# Privacy: disable metrics and crash reporting
defaults write com.google.Chrome MetricsReportingEnabled -bool false

# Privacy: disable URL-keyed anonymized data collection
defaults write com.google.Chrome UrlKeyedAnonymizedDataCollectionEnabled -bool false

# Disable built-in password manager (use 1Password instead)
defaults write com.google.Chrome PasswordManagerEnabled -bool false

# Disable AutoFill for addresses and credit cards
defaults write com.google.Chrome AutofillAddressEnabled -bool false
defaults write com.google.Chrome AutofillCreditCardEnabled -bool false

# Enable Safe Browsing (standard protection)
defaults write com.google.Chrome SafeBrowsingProtectionLevel -int 1

# Disable promotional content
defaults write com.google.Chrome PromotionalTabsEnabled -bool false

####################################
# Arc Browser

# Privacy: block third-party cookies
defaults write company.thebrowser.Browser BlockThirdPartyCookies -bool true

# Privacy: disable search suggestions
defaults write company.thebrowser.Browser SearchSuggestEnabled -bool false

# Privacy: disable metrics and crash reporting
defaults write company.thebrowser.Browser MetricsReportingEnabled -bool false

# Privacy: disable URL-keyed anonymized data collection
defaults write company.thebrowser.Browser UrlKeyedAnonymizedDataCollectionEnabled -bool false

# Disable built-in password manager (use 1Password instead)
defaults write company.thebrowser.Browser PasswordManagerEnabled -bool false

# Disable AutoFill for addresses and credit cards
defaults write company.thebrowser.Browser AutofillAddressEnabled -bool false
defaults write company.thebrowser.Browser AutofillCreditCardEnabled -bool false

# Enable Safe Browsing (standard protection)
defaults write company.thebrowser.Browser SafeBrowsingProtectionLevel -int 1

# Disable the all too sensitive backswipe on trackpads
defaults write company.thebrowser.Browser AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write company.thebrowser.Browser AppleEnableMouseSwipeNavigateWithScrolls -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Arc" \
	"cfprefsd" \
	"Dock" \
	"Finder" \
	"Google Chrome" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Terminal"; do
	killall "${app}" &> /dev/null
done
echo "Done!"
