# Script to unpack application from dmg into goinfre

cd "$HOME/Temp/"

hdiutil attach Obsidian-1.6.7.dmg
rm -rf "$HOME/goinfre/Obsidian.app"
mv "/Volumes/Obsidian 1.6.7-universal/Obsidian.app" "$HOME/goinfre"
hdiutil detach "/Volumes/Obsidian 1.6.7-universal"
