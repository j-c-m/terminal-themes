#!/usr/bin/env bash

# Theme:    IBM 5153 CGA
# Mode:     dark
# Source:   int10h.org (https://int10h.org/blog/2022/06/ibm-5153-color-true-cga-palette/)

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
    print_osc4 0 "26/26/26"
    print_osc4 1 "db/33/33"
    print_osc4 2 "33/db/33"
    print_osc4 3 "db/98/33"
    print_osc4 4 "33/33/db"
    print_osc4 5 "db/33/db"
    print_osc4 6 "33/db/db"
    print_osc4 7 "d6/d6/d6"
    print_osc4 8 "4e/4e/4e"
    print_osc4 9 "dc/4e/4e"
    print_osc4 10 "4e/dc/4e"
    print_osc4 11 "f3/f3/4e"
    print_osc4 12 "4e/4e/dc"
    print_osc4 13 "f3/4e/f3"
    print_osc4 14 "4e/f3/f3"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "d6/d6/d6"
    print_osc_rgb 11 "26/26/26"
    print_osc_rgb 12 "d6/d6/d6"
    print_osc_rgb 17 "d6/d6/d6"
    print_osc_rgb 19 "26/26/26"
}

do_linux() {
    print_linux 0 "#262626"
    print_linux 1 "#db3333"
    print_linux 2 "#33db33"
    print_linux 3 "#db9833"
    print_linux 4 "#3333db"
    print_linux 5 "#db33db"
    print_linux 6 "#33dbdb"
    print_linux 7 "#d6d6d6"
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
