#!/bin/bash
try=0
retval=666
SCRIPT=$(basename $0)
MAXTRIES=3
VERBOSE=0
SNAPSHOT=0
MIRROR=""

log_info() {
    logger -p user.info -t ${SCRIPT} "$*"
    [ $VERBOSE -eq 1 ] && echo "[INFO] $*"
}

log_error() {
    logger -p user.error -t ${SCRIPT} "$*"
    echo "[ERROR] $*" >&2
}

update_mirror() {
    if [[ "$1" == "" ]]; then
        log_error "Mirror has to be specified."
        exit 3
    fi
    while [[ $retval -ne 0 && $try -lt $MAXTRIES ]]; do
        log_info "Starting update of mirror ${1}"
        if [[ $VERBOSE -eq 0 ]]; then
            out=$(aptly mirror update -force=true ${1} >/dev/null 2>&1)
        else
            aptly mirror update -force=true ${1}
        fi

        retval=$?

        if [[ $retval -ne 0 ]]; then
            try=$[ $try + 1 ]
            log_error "Failed to update mirror ${1}, try=${try}"
            [ ! -z "$out" ] && log_error "${out}"
        else
            log_info "Synced mirror ${1}"
            if [[ $SNAPSHOT -eq 1 ]]; then
                snapshot_name="${1}-$(date +%s)"
                if [[ $VERBOSE -eq 0 ]]; then
                    out=$(aptly snapshot create ${snapshot_name} from mirror ${1} >/dev/null 2>&1)
                else
                    aptly snapshot create ${snapshot_name} from mirror ${1}
                fi

                retval=$?
                if [[ $retval -ne 0 ]]; then
                    log_error "Failed to create snapshot ${snapshot_name} from mirror ${1}"
                    [ ! -z "$out" ] && log_error "$out"
                else
                    log_info "Created snapshot ${snapshot_name} from mirror ${1}"
                fi
            fi
            break
        fi
    done
    try=0
    retval=666
}

while getopts "m:s?v?"  option
do
 case "${option}"
 in
 m|\?) MIRROR=${OPTARG};;
 s|\?) SNAPSHOT=1;;
 v|\?) VERBOSE=1;;
 esac
done

if [[ "$MIRROR" != "" ]]; then
    MIRROR_DETAIL=$(aptly mirror show ${MIRROR})
    if [[ $? -ne 0 ]]; then
        log_error "$MIRROR_DETAIL"
        exit 1
    fi
    update_mirror "${MIRROR}"
else
    MIRRORS=$(aptly mirror list --raw 2>&1)
    if [[ $? -ne 0 ]]; then
        log_error "$MIRRORS"
        exit 1
    fi
    for mirror in $MIRRORS; do
        update_mirror "${mirror}"
    done
fi
