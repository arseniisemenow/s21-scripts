# Script to unpack application from dmg into goinfre

cd "$HOME/Temp/"

hdiutil attach tsetup.4.16.8.dmg
mv "/Volumes/Telegram Desktop/Telegram.app" "$HOME/goinfre"
hdiutil detach "/Volumes/Telegram Desktop"
