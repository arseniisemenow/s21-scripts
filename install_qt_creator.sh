cd "$HOME/Temp/"

hdiutil attach qt-creator-opensource-mac-x86_64-7.0.0.dmg
cp -rf "/Volumes/Qt Creator/Qt Creator.app" "$HOME/goinfre"
hdiutil detach "/Volumes/Qt Creator"