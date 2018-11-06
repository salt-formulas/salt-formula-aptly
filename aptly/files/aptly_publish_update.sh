#!/bin/bash
############################################
# Aptly publish update helper
#
############################################

## Variables ## ============================
############### ============================
CLEANUP=0
VERBOSE=0
START_API=0
RECREATE=0
FORCE_OVERWRITE=0
PUBLISHER_OPTIONS=""
TIMEOUT=3600
COMMAND=`basename $0`

## Functions ## ============================
############### ============================
log_info() {
    logger -p user.info -t ${COMMAND} "$*"
    [ $VERBOSE -gt 0 ] && echo "[INFO] $*"
}

log_error() {
    logger -p user.error -t ${COMMAND} "$*"
    echo "[ERROR] $*" >&2
}

at_exit() {
    pgrep -f "aptly api serve" | xargs kill -15
}


## Usage ## --------------------------------
Usage() {
    cat <<EOF

Usage:
    $COMMAND [-h] [-qv] [-acrf]

Updates aptly publishes.

Parameters:
    -h ... this help
    -v ... more verbosity
    -q ... less verbosity
    -a ... start aptly api server
    -c ... cleanup unused snapshots
    -r ... drop publish and create it again, the only way to add new components
    -f ... overwrite files in pool directory without notice
    -t ... publisher timeout in seconds [3600]

EOF
    exit
}
## Usage end ## ----------------------------

## Main ## =================================
########## =================================

## Getparam ## -----------------------------
while [[ -n "$1" ]]; do
    i=$(expr substr $1 1 1)
    if [[ $i == '-' ]]; then
        r=$(expr substr $1 2 255)
        while [[ -n "$r" ]]; do
            i=$(expr substr $r 1 1)
            case "$i" in
                h) Usage ;;
                q) let "VERBOSE -= 1" ;;
                v) let "VERBOSE += 1" ;;
                a) START_API=1 ;;
                c) CLEANUP=1 ;;
                r) RECREATE=1 ;;
                f) FORCE_OVERWRITE=1 ;;
                u) URL=$2; shift ;;
                t) TIMEOUT=$2; shift ;;
            esac
            r=$(expr substr $r 2 255)
        done
    else
        parms="$parms $1"
    fi
    shift
done
## Getparam end ## -------------------------

: ${URL:="http://127.0.0.1:8080"}

if [[ $START_API -eq 1 ]]; then
    trap at_exit EXIT
    nohup aptly api serve --no-lock > /dev/null 2>&1 </dev/null &
fi
if [[ $RECREATE -eq 1 ]]; then
    PUBLISHER_OPTIONS+=" --recreate"
fi
if [[ $FORCE_OVERWRITE -eq 1 ]]; then
     PUBLISHER_OPTIONS+=" --force-overwrite"
fi

aptly-publisher --timeout=${TIMEOUT} publish -v -c /etc/aptly/publisher.yaml --url ${URL} --architectures amd64 $PUBLISHER_OPTIONS

if [[ $? -ne 0 ]]; then
    log_error "Aptly publisher failed."
    exit 1
fi

if [[ $CLEANUP -eq 1 ]]; then
    SNAPSHOT_LIST="$(aptly snapshot list --raw)"
    if [[ "$SNAPSHOT_LIST" != "" ]]; then
        log_info "Deleting unpublished snapshots."
        echo $SNAPSHOT_LIST | grep -E '*' | xargs -n 1 aptly snapshot drop
    fi
    log_info "Cleaning Aptly DB."
    aptly db cleanup
fi
exit 0
