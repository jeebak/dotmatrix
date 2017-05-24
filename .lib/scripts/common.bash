#!/usr/bin/env bash

# http://stackoverflow.com/a/6110446 (this was cool, but wouldn't allow for
# call stack via caller, BASH_SOURCE, FUNCNAME
set -e
# shellcheck disable=SC2154
# trap 'prev_cmd=$this_cmd; this_cmd=$BASH_COMMAND' DEBUG
# shellcheck disable=SC2154
# trap 'EC=$?; BAD_CMD="$prev_cmd"; [[ $EC -ne 0 ]] && die "Exit: $EC, due to: $BAD_CMD"' EXIT

CACHE_ROOT="$HOME/.cache/dotfiles"

# http://wiki.bash-hackers.org/commands/builtin/caller
die() {
  local frame=0

  echo "    Error: $1"
  echo "      Caller Frame(s):"

  while caller $frame; do
    ((frame++));
  done | sed 's/^/line: /' | column -t | sed 's/^/        /'

  # printf '        %s\n' "${BASH_SOURCE[@]}"
  # printf '        %s\n' "${FUNCNAME[@]}"

  exit 1
}

# Quiet stdout and stderr
qt() {
  "$@" > /dev/null 2>&1
}

# Quiet stderr
qte() {
  "$@" 2> /dev/null
}

cmd_exists() {
  command -v "$1" > /dev/null 2>&1
}

cache_mkdir_p () {
  for i in "$@"; do
   # shellcheck disable=SC2015
    [[ ! -d "$CACHE_ROOT/$i" ]] && mkdir -p "$CACHE_ROOT/$i" || true
  done
}

cache_mkdir_p "$CACHE_ROOT"

# $1 is relative to $HOME
# $2 is relative to $CACHE_ROOT
cache_verifylink () {
  [[ "$(readlink "$HOME/$1")" == "$CACHE_ROOT/$2" ]] \
    || die "\$(readlink $HOME/$1) != $CACHE_ROOT/$2"
}

# $1 is relative to $HOME
# $2 is relative to $CACHE_ROOT
cache_makelink () {
   # shellcheck disable=SC2015
  [[ ! -e "$HOME/$1" ]] && ln -svf "$CACHE_ROOT/$2" "$HOME/$1" || true
}

cache_shallow_clone () {
   # shellcheck disable=SC2015
  [[ ! -d "$CACHE_ROOT/$2" ]] && git clone --depth 1 "$1" "$CACHE_ROOT/$2" || true

  qt pushd "$CACHE_ROOT/$2"
# git reflog expire --expire=now --all
# git gc --aggressive --prune=now
  git submodule init && git submodule update
  qt popd
}
# -----------------------------------------------------------------------------
pkg-install() {
  [[ -z "$PKG_TYPE" ]] && die "PKG_TYPE not set!"
  local i pkg _type

  for i in $PKG_TYPE; do
    pkg="$*"
    _type="$i"

    if [[ $i == *":"* ]]; then
      _type="${i%:*}"
      pkg="${i#*:}"
    fi

    echo "$(tput setaf 5)    Running: $(tput setaf 3)${_type}-install $pkg$(tput sgr0)"
    "${_type}"-install "$pkg" && return 0
  done
}

pkg-uninstall() {
  [[ -z "$PKG_TYPE" ]] && die "PKG_TYPE not set!"
  local i pkg _type

  for i in $PKG_TYPE; do
    pkg="$*"
    _type="$i"

    if [[ $i == *":"* ]]; then
      _type="${i%:*}"
      pkg="${i#*:}"
    fi

    "${_type}"-uninstall "$pkg" && return 0
  done
}
# -----------------------------------------------------------------------------
brew-cask-is-installed() {
  qt brew cask list --versions "$@"
}

brew-is-installed() {
  qt brew list --versions "$@"
}

brew-is-tapped() {
  brew tap | qt grep "$@"
}

brew-cask-install() {
  brew-cask-is-installed "$@" || brew cask install "$@"
}

brew-cask-uninstall() {
  brew-cask-is-installed "$@" && brew cask uninstall "$@"
}

brew-install() {
  brew-is-installed "$@" || brew install "$@"
}

brew-uninstall() {
  brew-is-installed "$@" && brew uninstall "$@"
}

brew-tap() {
  brew-is-tapped "$@" || brew tap "$@"
}

brew-untap() {
  brew-is-tapped "$@" && brew untap "$@"
}
# -----------------------------------------------------------------------------
gem-is-installed() {
  qt gem list -i "$@"
}

gem-install() {
  gem-is-installed "$@" || gem install "$@"
}

gem-uninstall() {
  gem-is-installed "$@" && gem uninstall "$@"
}
# -----------------------------------------------------------------------------
npm-is-installed() {
  qt npm list -g --depth=0 "$@"
}

npm-install() {
  npm-is-installed "$@" || npm install -g "$@"
}

npm-uninstall() {
  npm-is-installed "$@" && npm uninstall -g "$@"
}
# -----------------------------------------------------------------------------
pip-is-installed() {
  qt pip show "$@"
}

pip-install() {
  pip-is-installed "$@" || pip install "$@"
}

pip-uninstall() {
  pip-is-installed "$@" && pip uninstall "$@"
}
