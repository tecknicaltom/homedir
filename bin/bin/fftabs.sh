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

~/mozilla-session/lz4json/lz4jsoncat .mozilla/firefox/8vwtga7o.default/sessionstore-backups/recovery.jsonlz4 | jq -r '
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

