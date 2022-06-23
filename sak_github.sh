#!/usr/bin/env bash
PATH="/bin:/usr/bin"

# Map a provided user to a github user
case "$1" in
	"tekicode")	gitkeys="tekicode";;

	# Fallthrough
	*)	gitkeys="tekicode";;
esac

# Silent curl, suppres errors on failure, no more than 5 seconds to fetch, save in /var/tmp
/usr/bin/curl -s --fail --max-time 5 -o /var/tmp/${gitkeys}.authkeys.tmp https://github.com/${gitkeys}.keys
ret=$?

# If ret is somehow unset, we'll fail by default.
if [ ${ret:-1} -gt 0 ]; then
	# Try to dump this file if it exists or not.
	/bin/cat /var/tmp/${gitkeys}.authkeys 2>/dev/null
	# If it existed, we'll exit 0, otherwise >0
	exit $?
else
	# dump the downloaded tmp file, then copy it to the primary authkeys file
	/bin/cat /var/tmp/${gitkeys}.authkeys.tmp && \
	/bin/mv /var/tmp/${gitkeys}.authkeys.tmp /var/tmp/${gitkeys}.authkeys && \
	/usr/bin/logger -t "sak_github" "Got keys for user [$1] using keysource github.com/${gitkeys}.keys"
	exit 0
fi

