#!/bin/bash

YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[1;31m'
NC='\033[0m'

MAGIC_METHODS="__destruct|__wakeup|__sleep|__call|__callStatic|__get|__set|__isset|__unset|__toString|__invoke|__set_state|__clone|__debugInfo"

echo '[+] looking for magic methods...'

grep -EnR --include="*.php" "$MAGIC_METHODS" . \
| sed 's|^\./||' \
| awk -v Y="$YELLOW" -v C="$CYAN" -v R="$RED" -v NC="$NC" '
{
    split($0, parts, ":");
    file = parts[1];
    line = parts[2];
    rest = substr($0, length(file) + length(line) + 3);

    gsub(/__construct|__destruct|__wakeup|__sleep|__callStatic|__call|__get|__set|__isset|__unset|__toString|__invoke|__set_state|__clone|__debugInfo/,
         R "&" NC, rest);

    printf "%s%s%s:%s%s%s: %s\n", Y, file, NC, C, line, NC, rest;
}'
