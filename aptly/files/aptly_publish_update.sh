#!/bin/bash
CLEANUP=0
VERBOSE=0
START_API=0
RECREATE=0
FORCE_OVERWRITE=0
PUBLISHER_OPTIONS=""

log_info() {
    logger -p user.info -t ${SCRIPT} "$*"
    [ $VERBOSE -eq 1 ] && echo "[INFO] $*"
}

log_error() {
    logger -p user.error -t ${SCRIPT} "$*"
    echo "[ERROR] $*" >&2
}

at_exit() {
    pgrep -f "aptly api serve" | xargs kill -15
}
trap at_exit EXIT

while getopts "a?c?f?r?v?"  option
do
 case "${option}"
 in
 a|\?) START_API=1;;
 c|\?) CLEANUP=1;;
 f|\?) FORCE_OVERWRITE=1;;
 r|\?) RECREATE=1;;
 v|\?) VERBOSE=1;;
 esac
done

if [[ $START_API -eq 1 ]]; then
    nohup aptly api serve --no-lock > /dev/null 2>&1 </dev/null &
fi
if [[ $RECREATE -eq 1 ]]; then
    PUBLISHER_OPTIONS+=" --recreate"
fi
if [[ $FORCE_OVERWRITE -eq 1 ]]; then
     PUBLISHER_OPTIONS+=" --force-overwrite"
fi

aptly-publisher --timeout=1200 publish -v -c /etc/aptly-publisher.yaml --url http://127.0.0.1:8080 --architectures amd64 $PUBLISHER_OPTIONS

if [[ $? -ne 0 ]]; then
    echo "Aptly Publisher failed."
    exit 1
fi

if [[ $CLEANUP -eq 1 ]]; then
    SNAPSHOT_LIST="$(aptly snapshot list --raw)"
    if [[ "$SNAPSHOT_LIST" != "" ]]; then
        log_info "Deleting unpublished snapshots"
        echo $SNAPSHOT_LIST | grep -E '*' | xargs -n 1 aptly snapshot drop
    fi
    log_info "Cleaning Aptly DB"
    aptly db cleanup
fi
exit 0