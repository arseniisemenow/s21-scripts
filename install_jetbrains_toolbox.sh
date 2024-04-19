# Script to unpack application from dmg into goinfre

cd "$HOME/Temp/"

hdiutil attach jetbrains-toolbox-2.2.3.20090.dmg
mv "/Volumes/JetBrains Toolbox/JetBrains Toolbox.app" "$HOME/goinfre"
hdiutil detach "/Volumes/JetBrains Toolbox"
