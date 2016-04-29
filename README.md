# Docker build tools for debian

Bash scripts for use in a debian based Dockerfile.

## Why?

When working with debian based `Dockerfile`, I often find in a situation where I copy paste the same code over and over. This is a (stop gap) solution to get around that.

## How do I use this?

Since docker does not provide means to do this (for good reasons), you will have to import it into the Dockerfile yourself (using `wget` for example) as shown below.
Then you need to `source` the `functions.sh` file to import handy functions that will help simplify basic debian package management tasks.
I have made a few assumptions here

1. Out of the installed packages, you want to keep some and remove the others. The ones that you want to remove are just build dependencies.
2. One of the `RUN` directives does most of the package management lifting, so that you wouldn't have to repeat the setup of build-tools more than once.

```
FROM debian:jessie
ENV BUILD_TOOLS_VERSION=1.0.0
...
RUN ( \
  wget -O- https://github.com/redmatter/debian-docker-build-tools/archive/{BUILD_TOOLS_VERSION}.tar.gz | tar -C /tmp/build-tools -xzf -
  source /tmp/build-tools/functions.sh
  ...
  _install pkg1 pkg2
  _install_for_build pkg3
  ...
  _uninstall pkg3
  # does auto clean-up; set _auto_cleanup=0 if you do not want this to happen
)

CMD "/bin/bash"
