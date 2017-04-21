#!/usr/bin/env bash

# http://stackoverflow.com/a/6110446
set -e
# shellcheck disable=SC2154
trap 'prev_cmd=$this_cmd; this_cmd=$BASH_COMMAND' DEBUG
# shellcheck disable=SC2154
trap 'EC=$?; BAD_CMD="$prev_cmd"; [[ $EC -ne 0 ]] && echo "Exit: $EC, due to: $BAD_CMD"' EXIT

CACHE_ROOT="$HOME/.cache/dotfiles"

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
  [[ "$(readlink "$HOME/$1")" == "$CACHE_ROOT/$2" ]]
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
