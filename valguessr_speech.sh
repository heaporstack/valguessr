#!/usr/bin/env bash

function speech {
    printf "[\033[32;1mValguessr\033[0m] $1 > $2"
}

if [ $# -eq 1 ]; then
    face=
    random=$(expr $RANDOM % 8)
    case $random in
        0) face=😏 ;;
        1) face=😅 ;;
        2) face=😋 ;;
        3) face=🤔 ;;
        4) face=😑 ;;
        5) face=😬 ;;
        6) face=🙄 ;;
        7) face=😯 ;;
    esac
    speech $face "$1"
elif [ $# -eq 2 ]; then
    speech $1 "$2"
fi
