# Script to unpack application from dmg into goinfre

cd "$HOME/Temp/"

hdiutil attach Miro.dmg
mv "/Volumes/Miro/Miro.app" "$HOME/goinfre"
hdiutil detach "/Volumes/Miro"
