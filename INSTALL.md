# Install with [Homebrew][] (Mac OS X only)

If you have [Homebrew][] installed you can easily install `git-pinch`:

    brew tap nnutter/homebrew-misc
    brew install git-pinch

[Homebrew]: http://brew.sh

# Install with PPA (Ubuntu only)

    sudo add-apt-repository ppa:nnutter/git-pinch
    sudo apt-get update
    sudo apt-get install git-pinch

# Install using Makefile

You can install from source using `make`:

    make install prefix=$PREFIX
