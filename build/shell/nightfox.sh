#!/usr/bin/env bash

# Theme:    Nightfox
# Mode:     dark
# Source:   Eden East (https://github.com/EdenEast/nightfox.nvim)

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
    print_osc4 0 "39/3b/44"
    print_osc4 1 "c9/4f/6d"
    print_osc4 2 "81/b2/9a"
    print_osc4 3 "db/c0/74"
    print_osc4 4 "71/9c/d6"
    print_osc4 5 "9d/79/d6"
    print_osc4 6 "63/cd/cf"
    print_osc4 7 "df/df/e0"
    print_osc4 8 "57/58/60"
    print_osc4 9 "d1/69/83"
    print_osc4 10 "8e/ba/a4"
    print_osc4 11 "e0/c9/89"
    print_osc4 12 "86/ab/dc"
    print_osc4 13 "ba/a1/e2"
    print_osc4 14 "7a/d5/d6"
    print_osc4 15 "e4/e4/e5"

    print_osc_rgb 10 "cd/ce/cf"
    print_osc_rgb 11 "19/23/30"
    print_osc_rgb 12 "cd/ce/cf"
    print_osc_rgb 17 "2b/3b/51"
    print_osc_rgb 19 "cd/ce/cf"
}

do_linux() {
    print_linux 0 "#393b44"
    print_linux 1 "#c94f6d"
    print_linux 2 "#81b29a"
    print_linux 3 "#dbc074"
    print_linux 4 "#719cd6"
    print_linux 5 "#9d79d6"
    print_linux 6 "#63cdcf"
    print_linux 7 "#dfdfe0"
    print_linux 8 "#575860"
    print_linux 9 "#d16983"
    print_linux 10 "#8ebaa4"
    print_linux 11 "#e0c989"
    print_linux 12 "#86abdc"
    print_linux 13 "#baa1e2"
    print_linux 14 "#7ad5d6"
    print_linux 15 "#e4e4e5"
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
