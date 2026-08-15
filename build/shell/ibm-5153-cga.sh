#!/usr/bin/env bash

# Theme:    IBM 5153 CGA
# Mode:     dark
# Source:   int10h.org (https://int10h.org/blog/2022/06/ibm-5153-color-true-cga-palette/)
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
    print_osc4 0 "14/14/14"
    print_osc4 1 "d0/33/33"
    print_osc4 2 "1b/d0/1b"
    print_osc4 3 "d0/8c/1b"
    print_osc4 4 "1b/1b/d0"
    print_osc4 5 "d0/1b/d0"
    print_osc4 6 "1b/d0/d0"
    print_osc4 7 "ce/ce/ce"
    print_osc4 8 "4e/4e/4e"
    print_osc4 9 "dc/4e/4e"
    print_osc4 10 "4e/dc/4e"
    print_osc4 11 "f3/f3/4e"
    print_osc4 12 "4e/4e/dc"
    print_osc4 13 "f3/4e/f3"
    print_osc4 14 "4e/f3/f3"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "ce/ce/ce"
    print_osc_rgb 11 "14/14/14"
    print_osc_rgb 12 "ce/ce/ce"
    print_osc_rgb 17 "ce/ce/ce"
    print_osc_rgb 19 "14/14/14"
}

do_linux() {
    print_linux 0 "#141414"
    print_linux 1 "#d03333"
    print_linux 2 "#1bd01b"
    print_linux 3 "#d08c1b"
    print_linux 4 "#1b1bd0"
    print_linux 5 "#d01bd0"
    print_linux 6 "#1bd0d0"
    print_linux 7 "#cecece"
    print_linux 8 "#4e4e4e"
    print_linux 9 "#dc4e4e"
    print_linux 10 "#4edc4e"
    print_linux 11 "#f3f34e"
    print_linux 12 "#4e4edc"
    print_linux 13 "#f34ef3"
    print_linux 14 "#4ef3f3"
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
