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

  # choose some runtime dependencies
  _choose_package pkg1 pkg2

  # choose some build dependencies
  _choose_package -build-dep pkg3 pkg4

  # install chosen packages and pkg5
  _install_package pkg5

  ...

  # remove a package (use -now option to remove it now rather than during auto-cleanup)
  _remove_package pkg1

  # does auto clean-up; set _do_auto_cleanup=false if you do not want this to happen
  # ... auto cleanup happens here
)

CMD "/bin/bash"
```

## Contributions

Please feel free to submit bugs and pull requests; always make sure you log a bug before making changes so that the work can be easily reviewed with appropriate context.

## Coding Standards and Ethics

Use common sense; follow what you see in the file you are modifying. I will be happy to accomodate variations as long as you can reason it, the code is well written and it is maintainable.

## LICENSE

This code is licensed under MIT license. See [`LICENSE`](LICENSE) for details.
