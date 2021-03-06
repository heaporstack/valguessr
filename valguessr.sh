#!/usr/bin/env bash

min=
max=

function get_nb_players {
    while true; do
        ./valguessr_speech.sh ๐คจ "Number of players (1 or 2) ? "
        read nb_players
        if [ -z $nb_players ]; then
            ./valguessr_speech.sh ๐ "You entered no value.\n"
            continue
        elif ! [[ "$nb_players" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh ๐ "Your value is not an integer.\n"
            continue
        elif [ $nb_players -lt 1 ] || [ $nb_players -gt 2 ]; then
            ./valguessr_speech.sh ๐ "The entered value is not in the interval [1; 2].\n"
            continue
        fi
        return $nb_players
    done
}

function get_interval_value {
    while true; do
        if [ $1 == "min" ]; then
            ./valguessr_speech.sh ๐คจ "Minimum possible value to guess ? "
        else
            ./valguessr_speech.sh ๐คจ "Maximum possible value to guess ? "
        fi
        read value
        if [ -z $value ]; then
            ./valguessr_speech.sh ๐ "You entered no value.\n"
            continue
        elif ! [[ "$value" =~ ^[0-9]+$ ]]; then
            ./valguessr_speech.sh ๐ "Your value is not an integer.\n"
            continue
        elif [ $1 == "min" ]; then
            min=$value
        else
            max=$value
        fi
        break
    done
}

function start_game {
    if [ $nb_players -eq 1 ]; then
        ./valguessr_speech.sh ๐ "One player mode selected, you must choose a values interval.\n"
    else
        ./valguessr_speech.sh ๐ "Two players mode selected, agree among yourselves to choose a values interval.\n"
    fi
    get_interval_value min
    while true; do
        get_interval_value max
        if [ $max -gt $min ]; then
            break
        fi
        ./valguessr_speech.sh ๐คช "Are you currently testing me ?\n"
    done
    if [ $nb_players -eq 1 ]; then
        ./one_player_mode.sh $min $max
    else
        ./two_players_mode.sh $min $max
    fi
}

./valguessr_speech.sh ๐ "Hello !\n"
get_nb_players
start_game
