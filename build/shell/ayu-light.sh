#!/usr/bin/env bash

# Theme:    Ayu Light
# Mode:     light
# Source:   Ayu Theme (https://github.com/ayu-theme)
# License:  MIT

# Exit if not on a tty

if [[ ! -t 0 ]]; then
    exit 0
fi

print_osc4() {
    local color="$1"
    local hexterm="$2"

    printf "\033]4;%d;rgb:%s\033\\" "$color" "$hexterm"
}

print_osc_rgb() {
    local osc="$1"
    local hexterm="$2"

    printf "\033]%d;rgb:%s\033\\" "$osc" "$hexterm"
}

print_linux() {
    local color="$1"
    local hex="$2"

    printf "\033]P%x%s" "$color" "${hex#\#}"
}

do_osc() {
    print_osc4 0 "00/00/00"
    print_osc4 1 "ea/6c/6d"
    print_osc4 2 "6c/bf/43"
    print_osc4 3 "ec/a9/44"
    print_osc4 4 "31/99/e1"
    print_osc4 5 "9e/75/c7"
    print_osc4 6 "46/ba/94"
    print_osc4 7 "c7/c7/c7"
    print_osc4 8 "68/68/68"
    print_osc4 9 "f0/71/71"
    print_osc4 10 "86/b3/00"
    print_osc4 11 "f2/ae/49"
    print_osc4 12 "39/9e/e6"
    print_osc4 13 "a3/7a/cc"
    print_osc4 14 "4c/bf/99"
    print_osc4 15 "d1/d1/d1"

    print_osc_rgb 10 "5c/61/66"
    print_osc_rgb 11 "f8/f9/fa"
    print_osc_rgb 12 "ff/aa/33"
    print_osc_rgb 17 "03/5b/d6"
    print_osc_rgb 19 "f8/f9/fa"
}

do_linux() {
    print_linux 0 "#000000"
    print_linux 1 "#ea6c6d"
    print_linux 2 "#6cbf43"
    print_linux 3 "#eca944"
    print_linux 4 "#3199e1"
    print_linux 5 "#9e75c7"
    print_linux 6 "#46ba94"
    print_linux 7 "#c7c7c7"
    print_linux 8 "#686868"
    print_linux 9 "#f07171"
    print_linux 10 "#86b300"
    print_linux 11 "#f2ae49"
    print_linux 12 "#399ee6"
    print_linux 13 "#a37acc"
    print_linux 14 "#4cbf99"
    print_linux 15 "#d1d1d1"
}

case "$TERM" in
    linux*)
        do_linux
        ;;
    *)
        do_osc
        ;;
esac

unset -f print_osc4
unset -f print_osc_rgb
unset -f print_linux
unset -f do_osc
unset -f do_linux
