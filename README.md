[![Build Status](https://travis-ci.org/nnutter/git-pinch.png?branch=master)](https://travis-ci.org/nnutter/git-pinch)

# git-pinch

`git-pinch` is a Git extension to enable "retroactive" creation of feature
branches.

A common use case might be that you start making a single "trivial" change in
`master` but end up making several commits.  If you decide you should have used
a feature branch then you would have to:

    git branch feature
    git reset --hard @{u}
    git merge --no-ff feature
    git branch -d feature

or instead:

    git pinch HEAD

More generally, when developing incremental steps (refactoring, etc.) can
sometimes lead to sets of changes that could themselves be described as
(sub)features. `git-pinch` automates the process of taking a linear set of
changes and grouping sets of them into merged feature branches.

For example, suppose you commit four changes (A, B, C, D) and then realize A and B
were really implementing some (sub)feature and C and D were another.  You could run,

    git pinch B D

the result would be:

    *   Merge in 'second feature' work
    |\
    | * D
    | * C
    |/
    *   Merge in 'first feature' work
    |\
    | * B
    | * A
    |/
    * @{u}

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
