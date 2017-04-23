# Dotfiles Management 

Skeleton template

* https://dotfiles.github.io/

blah blah, more words later

If there is any personal/private info, update git configs according to use a
private repo.

## Requirements/Installation:

[GNU Stow](https://www.gnu.org/software/stow/)

```
brew install stow
```

## Core files
```
  .
  ├── .gitignore
  ├── .lib
  │   ├── README.md
  │   └── scripts
  │       └── common.bash
  ├── Makefile
  └── README.md
```
Of these, the `Makefile` is the only one necessary at the bare minimum for
_"full"_ functionality. The `.lib/scripts/common.bash` file contains helper
functions for the `{pre,post}-` hook scripts, and is not strictly necessary.

TL;DR - the _"magic's"_ in the `Makefile`.

## Package Folders
Related package files are kept in each package folder. Anything out of the list
of core files above, would be considered package folders / files. All of these
other folders / files in this repo, outside of these core files, can be
considered examples for customizations. They can be kept, deleted, or updated
to fit your needs.

## Makefile

The _"magic's"_ in the `Makefile`. The default action is to `stow`. The action
is applied to a list of stowable targets (the package folders.)

 Examples:
```
  make            # defaults to: stow-all target/action
  make bash
  make vim zsh
```

There's also a little bit of
[Make](https://www.gnu.org/software/make/manual/html_node/Text-Functions.html)
trickery to allow you to specfify `unstow` or `restow` as actions. These can
only be specfied as the 1st argument. Additionally, there are `stow-all`,
`unstow-all`, `restow-all` targets.

Examples:
```
  make unstow bash vim zsh
  make restow bash vim zsh

  make stow-all   # default action
  make unstow-all
  make restow-all
```

# Hooks
Each package folder can optionally contain a `hooks` folder, containing
[Bash](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html) scripts, following
this structure:
```
  pkgname
  └── hooks
      ├── optional
      │   └── subfolders
      │       └── helpers.bash
      ├── pre-stow              # any, all. or none of...
      ├── post-stow
      ├── pre-unstow
      └── post-unstow
```
