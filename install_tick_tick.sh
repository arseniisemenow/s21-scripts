# Script to unpack application from dmg into goinfre

cd "$HOME/Temp/"

hdiutil attach TickTick_6.0.40_378.dmg
rm -rf "$HOME/goinfre/TickTick.app"
mv "/Volumes/TickTick/TickTick.app" "$HOME/goinfre"
hdiutil detach "/Volumes/TickTick"
