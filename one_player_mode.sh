#!/usr/bin/env bash

min=$1
max=$2
random=

function randomize {
    random=$(shuf -i $min-$max -n 1)
}

function game {
    tries=0
    ./valguessr_speech.sh 🧐 "Try to guess the value I chose : "
    while true; do
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh 🙁 "You entered no value : "
            continue
        elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh 🙁 "Your value is not an integer : "
            continue
        elif [ $value -lt $random ]; then
            tries=$(expr $tries + 1)
            ./valguessr_speech.sh "➕ : "
        elif [ $value -gt $random ]; then
            tries=$(expr $tries + 1)
            ./valguessr_speech.sh "➖ : "
        else
            tries=$(expr $tries + 1)
            if [ $tries -eq 1 ]; then
                ./valguessr_speech.sh 😱 "That's INSANE !!! You found the right number in $tries try !\n"
            elif [ $tries -lt 5 ]; then
                ./valguessr_speech.sh 🥳 "Well done ! You found the right number in $tries tries !\n"
            elif [ $tries -lt 10 ]; then
                ./valguessr_speech.sh 🤗 "Pretty good ! You found the right number in $tries tries !\n"
            else
                ./valguessr_speech.sh 🙂 "You found the right number in $tries tries !\n"
            fi
            break
        fi
    done
}

if ! [[ "$min" =~ ^[0-9]+$ ]] || ! [[ "$max" =~ ^[0-9]+$ ]]; then
    ./valguessr_speech.sh 🙁 "Inconsistent arguments.\n"
    exit 1
elif [ $max -le $min ]; then
    ./valguessr_speech.sh 🙁 "Inconsistent arguments.\n"
    exit 2
else
    randomize
    game
fi
