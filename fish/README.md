# fish-shell

_"The user-friendly command line shell."_

* https://fishshell.com/
* https://fishshell.com/docs/current/index.html
* https://github.com/fish-shell/fish-shell
* https://github.com/fisherman/fisherman
* https://github.com/jbucaran/awesome-fish
* https://github.com/oh-my-fish/oh-my-fish
* https://github.com/oh-my-fish/packages-main

## Installation

```
curl -L https://get.oh-my.fish | fish
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher

for pkg in (curl -s https://api.github.com/repos/oh-my-fish/packages-main/contents/packages | grep '"path"' | sed 's| *"path": "packages/||;s|",$||')
  omf describe $pkg
  echo "Install $pkg? [y/n] "
  read -l -n 1 yn
  if test $yn = y
    omf install $pkg
  end
end
```

## Paths

```
~/.config/fish
~/.local/share/fish

~/.config/omf
~/.local/share/omf
```
