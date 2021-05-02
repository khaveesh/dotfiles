#!/bin/zsh
#***************************************************************************
#*** noz - prevent laptop from sleeping when lid is closed
#***************************************************************************

#***** set some defaults *****
DEF_WAKE_LEN=10 # in seconds

#***** determine timeout value *****
timeout_len=${1:-$DEF_WAKE_LEN}

function prevent_sleep() {
    echo -n "Preventing sleep for $timeout_len seconds; press <enter> to continue..."

    sudo pmset disablesleep 1
}

function enable_sleep() {
    # $1: <enter> = 0, timeout = 1, Ctrl-C = undef

    #----- insert a newline for timeout or Ctrl-C -----
    if [[ ${1:-1} -eq 1 ]]; then    echo; fi
    echo "Restoring previous battery sleep setting: $BATTERY_SLEEP"

    sudo pmset disablesleep 0

    exit 0
}

#***** prevent it from sleeping *****
prevent_sleep

#***** trap Ctrl-C *****
trap enable_sleep INT

#***** wait for an enter *****
read -r -t "$timeout_len"
rc=$?

#***** re-enable normal sleep *****
enable_sleep $rc
