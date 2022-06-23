#!/usr/bin/env bash
PATH="/bin:/usr/bin"

age() { echo $(( $(/usr/bin/date +%s) - $(/usr/bin/date -r "$1" +%s) )); }

fetchkeys() {
	# Download the keyfile to a tmp file
	/usr/bin/curl -s --fail --max-time 5.5 -o "${2}.tmp" "https://github.com/${1}.keys"
	if [ $? -gt 0 ]; then
		/bin/cat "$2" 2>/dev/null
		exit $?
	else
		/bin/cat "${2}.tmp" && \
		/bin/mv "${2}.tmp" "${2}" && \
		/usr/bin/logger -t sak_github -p info "Fetched keys for user [$1] to keyfile [$2]" && \
		exit 0

		/usr/bin/logger -t sak_github -p error "Failed to fetch keys for user [$1] to keyfile [$2]."
		exit 1
	fi
}

# Don't do checks on user accounts that don't exist locally
if ! /usr/bin/id -u "$1" >/dev/null 2>&1; then
	exit 0
fi

# Map a provided user to a github user
case "$1" in
	"root")	gituser="tekicode";;

	# Catch-all
	*) gituser="tekicode";;
esac

keyfile="/var/tmp/${gituser}.pubkeys"
if [ -f "$keyfile" ]; then
	ageist=$(age "$keyfile")
	if [ "${ageist:-9999}" -gt 900 ]; then
		/usr/bin/logger -t sak_github -p info "Refreshing pubkeys for user [$1] keys [$keyfile] age: [$ageist]"
		fetchkeys "${gituser}" "$keyfile"
	else
		cat $keyfile 2>/dev/null
		exit $?
	fi
fi

fetchkeys "$gituser" "$keyfile"

