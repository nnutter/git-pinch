% GIT-PINCH(1) git-pinch 0.01 | git-pinch User Manuals
% Nathaniel Nutter \<git-pinch@nnutter.com\>
% January 27, 2014

# NAME

git-pinch - enable "retroactive" creation of feature branches

# SYNOPSIS

git pinch [--upstream \<upstream\>] \<commit\>...  

# DESCRIPTION

git-pinch is a Git extension to enable "retroactive" creation of feature
branches.

# OPTIONS

\--no-edit
:   Do not edit message before committing.

-u, \--upstream
:   Base off given commit instead of upstream.  If <upstream> is not specified,
    the current branch's upstream will be used.  If you are currently not on any
    branch or if the current branch does not have a configured upstream the
    command will abort.

-p, \--preserve-merges
:   Try to recreate merges instead of ignoring them.

# EXAMPLES

A common use case might be that you start making a single "trivial" change in
`master` but end up making several commits.  If you decide you should have used
a feature branch then you would have to:

    $ git branch feature
    $ git reset --hard @{u}
    $ git merge --no-ff feature
    $ git branch -d feature

or instead:

    $ git pinch HEAD

More generally, when developing incremental steps (refactoring, etc.) can
sometimes lead to sets of changes that could themselves be described as
(sub)features. `git-pinch` automates the process of taking a linear set of
changes and grouping sets of them into merged feature branches.

For example, suppose you commit four changes (A, B, C, D) and then realize A and B
were really implementing some (sub)feature and C and D were another.  You could run,

    $ git pinch B D

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

# SEE ALSO

`git-rebase` (1).

# BUGS

No known bugs.

# COPYRIGHT

Copyright (c) 2013, Nathaniel Nutter

This is free documentation; you can redistribute it and/or
modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of
the License, or (at your option) any later version.

The GNU General Public License's references to "object code"
and "executables" are to be interpreted as the output of any
document formatting or typesetting system, including
intermediate and printed output.

This manual is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this manual; if not, see
\<http://www.gnu.org/licenses/\>.
