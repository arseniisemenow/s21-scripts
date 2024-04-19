# Script to install homebrew into goinfre
# Will take some place in $HOME directory for caches

mkdir -p ~/goinfre/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/goinfre/homebrew