#!/usr/bin/env bash

# Theme:    Ayu Dark
# Mode:     dark
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
    print_osc4 0 "11/15/1c"
    print_osc4 1 "ea/6c/73"
    print_osc4 2 "7f/d9/62"
    print_osc4 3 "f9/af/4f"
    print_osc4 4 "53/bd/fa"
    print_osc4 5 "cd/a1/fa"
    print_osc4 6 "90/e1/c6"
    print_osc4 7 "c7/c7/c7"
    print_osc4 8 "68/68/68"
    print_osc4 9 "f0/71/78"
    print_osc4 10 "aa/d9/4c"
    print_osc4 11 "ff/b4/54"
    print_osc4 12 "59/c2/ff"
    print_osc4 13 "d2/a6/ff"
    print_osc4 14 "95/e6/cb"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "bf/bd/b6"
    print_osc_rgb 11 "0b/0e/14"
    print_osc_rgb 12 "e6/b4/50"
    print_osc_rgb 17 "40/9f/ff"
    print_osc_rgb 19 "0b/0e/14"
}

do_linux() {
    print_linux 0 "#11151c"
    print_linux 1 "#ea6c73"
    print_linux 2 "#7fd962"
    print_linux 3 "#f9af4f"
    print_linux 4 "#53bdfa"
    print_linux 5 "#cda1fa"
    print_linux 6 "#90e1c6"
    print_linux 7 "#c7c7c7"
    print_linux 8 "#686868"
    print_linux 9 "#f07178"
    print_linux 10 "#aad94c"
    print_linux 11 "#ffb454"
    print_linux 12 "#59c2ff"
    print_linux 13 "#d2a6ff"
    print_linux 14 "#95e6cb"
    print_linux 15 "#ffffff"
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
