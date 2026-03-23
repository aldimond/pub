#!/bin/sh

# Converts a timestamp to human-readable time. Tries to be smart about
# granularity.
awdate() {
    # This test complains about decimal input but returns false, which has the
    # reasonable result of assuming decimal seconds.
    while [ "${s}" -gt 100000000000 ] ; do
        # Assume smaller-than-seconds granularity; chop off 3 digits at a time.
        s="${s:0:-3}"
        echo -n '.' >&2
    done
    [ "${s}" != "$1" ] && echo >&2
    date -d "@${s}"
}
