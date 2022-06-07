#!/usr/bin/env bash

min=$1
max=$2
p1_name=
p2_name=
p1_val=
p2_val=
p1_tries=
p2_tries=

function get_name {
    if [ $1 == "p1" ]; then
        ./valguessr_speech.sh 🙂 "What is name of player 1 ? "
    else
        ./valguessr_speech.sh 🙂 "What is name of player 2 ? "
    fi
    while true; do
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh 🙁 "You entered no name : "
            continue
        fi
        if [ $1 == "p1" ]; then
            p1_name=$value
        else
            p2_name=$value
        fi
        break
    done
}

function get_val {
    if [ $1 == "p1" ]; then
        ./valguessr_speech.sh 🙂 "$p1_name must choose a value between $min and $max ($p2_name don't look at the value $p1_name is typing) : "
    else
        ./valguessr_speech.sh 🙂 "$p2_name must choose a value between $min and $max ($p1_name don't look at the value $p2_name is typing) : "
    fi
    while true; do
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh 🙁 "You entered no value : "
            continue
        elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh 🙁 "Your value is not a positive integer : "
            continue
        elif [ $value -gt $max ] || [ $value -lt $min ]; then
            ./valguessr_speech.sh 🙁 "The value you entered is not in the interval [$min; $max] : "
            continue
        fi
        if [ $1 == "p1" ]; then
            p1_val=$value
        else
            p2_val=$value
        fi
        clear
        break
    done
}

function game {
    random=$(expr $RANDOM % 2)
    case $random in
        0)
            game_p1
            game_p2
        ;;
        1)
            game_p2
            game_p1
        ;;
    esac
    if [[ $p1_tries -eq $p2_tries ]]; then
        if [ $p1_tries -eq 1 ]; then
            ./valguessr_speech.sh "Perfect EQUALITY !!! Both of you found the right answer in only $p1_tries try !\n"
        else
            ./valguessr_speech.sh "Perfect EQUALITY !!! Both of you found the right answer in $p1_tries tries !\n"
        fi
        elif [[ $p2_tries -gt $p1_tries ]]; then
        if [ $p1_tries -eq 1 ]; then
            ./valguessr_speech.sh "$p1_name won ! He found the right answer in only $p1_tries try and $p2_name found the answer in $p2_tries tries !\n"
        else
            ./valguessr_speech.sh "$p1_name won ! He found the right answer in $p1_tries tries and $p2_name found the answer in $p2_tries tries !\n"
        fi
    elif [[ $p1_tries -gt $p2_tries ]]; then
        if [ $p1_tries -eq 1 ]; then
            ./valguessr_speech.sh "$p2_name won ! He found the right answer in only $p2_tries try and $p1_name found the answer in $p1_tries tries !\n"
        else
            ./valguessr_speech.sh "$p2_name won ! He found the right answer in $p2_tries tries and $p1_name found the answer in $p1_tries tries !\n"
        fi
    fi
}

function game_p1 {
    p1_tries=0
    ./valguessr_speech.sh "$p1_name turn ! "
    while true; do
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh 🙁 "You entered no value : "
            continue
        elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh 🙁 "Your value is not an integer : "
            continue
        elif [ $value -lt $p2_val ]; then
            p1_tries=$(expr $p1_tries + 1)
            ./valguessr_speech.sh "➕ : "
        elif [ $value -gt $p2_val ]; then
            p1_tries=$(expr $p1_tries + 1)
            ./valguessr_speech.sh "➖ : "
        else
            p1_tries=$(expr $p1_tries + 1)
            if [ $p1_tries -eq 1 ]; then
                ./valguessr_speech.sh 😱 "That's INSANE !!! You found the right number in $p1_tries try !\n"
            elif [ $p1_tries -lt 5 ]; then
                ./valguessr_speech.sh 🥳 "Well done ! You found the right number in $p1_tries tries !\n"
            elif [ $p1_tries -lt 10 ]; then
                ./valguessr_speech.sh 🤗 "Pretty good ! You found the right number in $p1_tries tries !\n"
            else
                ./valguessr_speech.sh 🙂 "You found the right number in $p1_tries tries !\n"
            fi
            break
        fi
    done
}

function game_p2 {
    p2_tries=0
    ./valguessr_speech.sh "$p2_name turn ! "
    while true; do
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh 🙁 "You entered no value : "
            continue
        elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh 🙁 "Your value is not an integer : "
            continue
        elif [ $value -lt $p1_val ]; then
            p2_tries=$(expr $p2_tries + 1)
            ./valguessr_speech.sh "➕ : "
        elif [ $value -gt $p1_val ]; then
            p2_tries=$(expr $p2_tries + 1)
            ./valguessr_speech.sh "➖ : "
        else
            p2_tries=$(expr $p2_tries + 1)
            if [ $p2_tries -eq 1 ]; then
                ./valguessr_speech.sh 😱 "That's INSANE !!! You found the right number in $p2_tries try !\n"
            elif [ $p2_tries -lt 5 ]; then
                ./valguessr_speech.sh 🥳 "Well done ! You found the right number in $p2_tries tries !\n"
            elif [ $p2_tries -lt 10 ]; then
                ./valguessr_speech.sh 🤗 "Pretty good ! You found the right number in $p2_tries tries !\n"
            else
                ./valguessr_speech.sh 🙂 "You found the right number in $p2_tries tries !\n"
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
    get_name "p1"
    get_name "p2"
    get_val "p1"
    get_val "p2"
    game
fi
