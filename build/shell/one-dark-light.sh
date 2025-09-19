#!/usr/bin/env bash

# Theme:    One Dark Light
# Mode:     light
# Source:   One Dark (https://github.com/nathanbuchar/atom-one-dark-terminal)

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
    print_osc4 1 "e4/56/49"
    print_osc4 2 "50/a1/4f"
    print_osc4 3 "98/68/01"
    print_osc4 4 "40/78/f2"
    print_osc4 5 "a6/26/a4"
    print_osc4 6 "01/84/bc"
    print_osc4 7 "a0/a1/a7"
    print_osc4 8 "38/3a/42"
    print_osc4 9 "e8/6e/63"
    print_osc4 10 "5b/ae/5a"
    print_osc4 11 "a7/72/01"
    print_osc4 12 "5d/8c/f4"
    print_osc4 13 "b7/2a/b4"
    print_osc4 14 "01/91/cf"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "38/3a/42"
    print_osc_rgb 11 "f9/f9/f9"
    print_osc_rgb 12 "38/3a/42"
    print_osc_rgb 17 "38/3a/42"
    print_osc_rgb 19 "f9/f9/f9"
}

do_linux() {
    print_linux 0 "#000000"
    print_linux 1 "#e45649"
    print_linux 2 "#50a14f"
    print_linux 3 "#986801"
    print_linux 4 "#4078f2"
    print_linux 5 "#a626a4"
    print_linux 6 "#0184bc"
    print_linux 7 "#a0a1a7"
    print_linux 8 "#383a42"
    print_linux 9 "#e86e63"
    print_linux 10 "#5bae5a"
    print_linux 11 "#a77201"
    print_linux 12 "#5d8cf4"
    print_linux 13 "#b72ab4"
    print_linux 14 "#0191cf"
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
