#!/bin/sh

_is_initialised() {
    [ -n "$DEBIAN_FRONTEND" ];
}

_initialise() {
    if ! _is_initialised; then
        export DEBIAN_FRONTEND=noninteractive;
    fi
}

_choose_package() {
    _initialise
    if [ "$1" = '-build-dep' ]; then
        shift;
        BUILD_DEPS="$BUILD_DEPS $@"
    else
        APP_DEPS="$APP_DEPS $@"
    fi
}

_install_package() {
    _initialise
    if [ -z "$@$BUILD_DEPS$APP_DEPS" ]; then
        return 0;
    fi

    local packages="$@ $BUILD_DEPS $APP_DEPS"
    apt-get update; # get latest package list
    apt-get install -y --no-install-recommends ${packages};
}

_remove_package() {
    _initialise
    local now=false;
    if [ "$1" = '-now' ]; then
        shift;
        now=true;
    fi

    if [ $# -eq 0 ]; then
        return 0;
    fi

    if $now; then
        apt-get remove -y $@; \
        return;
    fi

    REMOVE="$REMOVE $@"
}

_remove_apt_artefacts() {
    apt-get clean autoclean;
    apt-get autoremove -y;
    rm -rf /var/lib/apt /var/lib/dpkg /var/lib/cache /var/lib/log;
}

_cleanup() {
    if _is_initialised; then
        _remove_package -now $REMOVE $BUILD_DEPS $(apt-mark showauto)
        _remove_apt_artefacts
        # TODO check need to re-install $APP_DEPS if 'apt-mark showauto' gets hold of them
    fi
}

: ${_do_auto_cleanup:=true}
_auto_cleanup() {
    if $_do_auto_cleanup; then
        _cleanup
    fi
}

trap '_auto_cleanup' EXIT INT TERM

