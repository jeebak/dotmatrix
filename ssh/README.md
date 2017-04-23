# Ssh

_"OpenSSH is the premier connectivity tool for remote login with the SSH protocol."_

* https://www.openssh.com/

SSH doesn't (or at least, shouldn't) allow the `~/.ssh/config` file to be
symlinked. The [post-stow](hooks/post-stow) hook script can be used to
"compile" it from several different files.

**NOTE:** If these configs contains any personal/private info, make sure your
dotsfile repo is private.
