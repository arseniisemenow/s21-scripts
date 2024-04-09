cd ~/Downloads/
hdiutil attach jetbrains-toolbox-2.2.3.20090.dmg

cp -rf "/Volumes/JetBrains Toolbox" "$HOME/goinfre"

#chmod +x ~/goinfre/Qt\ Creator.app

hdiutil detach "/Volumes/JetBrains Toolbox"