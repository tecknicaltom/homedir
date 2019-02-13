#!/bin/bash

PROG="$(cat ~/.fluxbox/menu | sed 's/#.*//' | perl -ne 'print "$1\n" if(/^\s*\[exec\] \(([^)]+)\)/)' | dmenu -i)"
EXE="$(cat ~/.fluxbox/menu | sed 's/#.*//' | perl -ne 'BEGIN { $label = shift } print "$2\n" if(/^\s*\[exec\] \(([^)]+)\) \{([^}]*)\}/ and $1 eq $label)' "$PROG")"
eval $EXE
