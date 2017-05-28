# yadm

_"Yet Another Dotfiles Manager"_

```
brew install yadm
```

The [func-depot](../scripts/.local/bin/func-depot) script contains a wrapper
function for `git` (and `yalm`) that will be `yadm` aware.


Currently using for private files in a **private** git repo, and for host
specific files (via `yalm`) also in a **private** git repo.

```
  ~/.aws/config
  ~/.aws/credentials

  ~/.config/dotfiles/private/git/user.conf
  # export HOMEBREW_GITHUB_API_TOKEN=coffeefacefedcodedadobebabebadedbadcoca0
  ~/.config/dotfiles/private/homebrew.sh
  ~/.config/dotfiles/private/mysql/my.cnf

  ~/.gnupg/DEADBEEF.gpg
  ~/.gnupg/FACEABBA.gpg

  ~/.ssh/config.d/10-main.conf
  ~/.ssh/config.d/20-private-stuff.conf
```

* https://thelocehiliosan.github.io/yadm/
* https://github.com/TheLocehiliosan/yadm
