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

See [INSTALL.md](https://github.com/nnutter/git-pinch/blob/master/INSTALL.md).
