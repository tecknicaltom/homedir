#!/bin/bash
set -eu

#~/mozilla-session/lz4json/lz4jsoncat .mozilla/firefox/8vwtga7o.default/sessionstore-backups/recovery.jsonlz4 | jq -r '
#.windows
#| map(.window_title = (.extData."extension:{35dd5f9a-ca89-4643-b107-f07d09cc94b5}:userWindowTitle" // "\"UNTITLED\"" | fromjson))
#| .[]
#| (
#    (.extData."extension:{35dd5f9a-ca89-4643-b107-f07d09cc94b5}:userWindowTitle" // "\"UNTITLED\"" | fromjson) + " " + (.tabs|length|tostring)
#) ' | \
#sort | perl -e 'while(<>){ chomp; /(.*) (\d+)/; $sum += $2; printf "%5d %s\n", $2, $1 } printf "%5d\n", $sum'

profile_file=""
if [[ $# -eq 1 ]]
then
	if [[ -d "$1" ]]
	then
		if [[ -e "$1/recovery.jsonlz4" ]]
		then
			profile_file="$1/recovery.jsonlz4"
		elif [[ -e "$1/sessionstore-backups/recovery.jsonlz4" ]]
		then
			profile_file="$1/sessionstore-backups/recovery.jsonlz4"
		fi
	elif [[ -e "$1" ]]
	then
		profile_file="$1"
	else
		if [[ -e "$HOME"/.mozilla/firefox/"$1"/sessionstore-backups/recovery.jsonlz4 ]]
		then
			profile_file="$HOME"/.mozilla/firefox/"$1"/sessionstore-backups/recovery.jsonlz4
		else
			profile_path="$(grep -A2 "Name=$1" "$HOME"/.mozilla/firefox/profiles.ini | grep Path= | sed 's#Path=##')"
			profile_file="$HOME"/.mozilla/firefox/"$profile_path"/sessionstore-backups/recovery.jsonlz4
		fi
	fi
else
	profile_path="$(grep -B2 "Default=1" "$HOME"/.mozilla/firefox/profiles.ini | grep Path= | sed 's#Path=##')"
	profile_file="$HOME"/.mozilla/firefox/"$profile_path"/sessionstore-backups/recovery.jsonlz4
fi

lz4jsoncat "$profile_file" | jq -r '
.windows
| map(.window_title = (.extData."extension:{35dd5f9a-ca89-4643-b107-f07d09cc94b5}:userWindowTitle" // "\"UNTITLED\"" | fromjson))
| sort_by(.window_title)
| .[]
| (
    (.window_title + " " + (.tabs|length|tostring)),
    (.tabs[] |
        (
            .entries[.index-1] | ("  " + .url + " " + .title)
        )
    )
) '

