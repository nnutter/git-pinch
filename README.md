[![Build Status](https://travis-ci.org/nnutter/git-pinch.png?branch=master)](https://travis-ci.org/nnutter/git-pinch)

# git-pinch

`git-pinch` is a Git extension to enable "retroactive" creation of feature
branches.

When developing incremental steps (refactoring, etc.) can sometimes lead to
sets of changes that could themselves be described as (sub)features.
`git-pinch` automates the process of taking a linear set of changes and
grouping sets of them into merged feature branches.

For example, suppose you commit four changes (A, B, C, D) and then realize B, C,
were really implementing some (sub)feature.  You could run,

    git pinch --upstream A C

the result would be:

    * D
    *   Merge in 'feature' work
    |\
    | * C
    | * B
    |/
    * A

# Installation

## Install with [Homebrew][] (Mac OS X only)

If you have [Homebrew][] installed you can easily install `git-pinch`:

    brew tap nnutter/homebrew-misc
    brew install git-pinch

[Homebrew]: http://brew.sh

## Install with PPA (Ubuntu only)

    sudo add-apt-repository ppa:nnutter/git-pinch
    sudo apt-get update
    sudo apt-get install git-pinch

## Install using Makefile

You can install from source using `make`:

    make install prefix=$PREFIX
