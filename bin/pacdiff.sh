#!/usr/bin/bash -e

#Check and merge pacsave and pacnew files in Arch linux.
#
# Author: <Ali Mousavi> ali.mousavi@gmail.com
# License: MIT
# Last Updated: 2016-07-03
#
# Inspired by pacsave script written by pbrisbin
#
###
if (( $UID )); then
  echo 'You must be root.' >&2
  exit 1
fi

if [ -x "$(hash vimdiff 2>/dev/null)" ]; then
    echo 'vimdiff not found'
    exit 1
fi

shopt -s globstar nullglob

set -- "${1:-/etc}"/**/*.pac{new,save}

(( $# )) || exit 1

for file; do
  current="${file/.pacnew/}"

  ${DIFFTOOL:-vimdiff} "$current" "$file"

  echo -e "You can either remove \033[1;33m$file\033[0m or merge it with \033[1;33m$current\033[0m."
  rm -iv "$file" # -i gets us prompting for free
  [[ -f "$file" ]] && mv -iv "$file" "$current"
done