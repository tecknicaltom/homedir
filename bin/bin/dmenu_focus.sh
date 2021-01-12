#!/bin/bash

title="$(wmctrl -l | cut -d' ' -f5- | sort | uniq | dmenu -i | perl -pe 's/([\[\].(){}*+])/\\$1/g')"
[[ ! -z "$title" ]] && focus "$title"
