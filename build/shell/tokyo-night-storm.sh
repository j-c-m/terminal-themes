#!/usr/bin/env bash

# Theme:    Tokyo Night Storm
# Mode:     dark
# Source:   Tokyo Night (https://github.com/tokyo-night/)

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
    print_osc4 0 "41/48/68"
    print_osc4 1 "f7/76/8e"
    print_osc4 2 "9e/ce/6a"
    print_osc4 3 "e0/af/68"
    print_osc4 4 "7a/a2/f7"
    print_osc4 5 "bb/9a/f7"
    print_osc4 6 "7d/cf/ff"
    print_osc4 7 "a9/b1/d6"
    print_osc4 8 "56/5f/89"
    print_osc4 9 "f9/98/aa"
    print_osc4 10 "ad/d6/81"
    print_osc4 11 "e6/bd/83"
    print_osc4 12 "9d/ba/f9"
    print_osc4 13 "d4/bf/fa"
    print_osc4 14 "a3/dd/ff"
    print_osc4 15 "c0/ca/f5"

    print_osc_rgb 10 "a9/b1/d6"
    print_osc_rgb 11 "24/28/3b"
    print_osc_rgb 12 "a9/b1/d6"
    print_osc_rgb 17 "a9/b1/d6"
    print_osc_rgb 19 "24/28/3b"
}

do_linux() {
    print_linux 0 "#414868"
    print_linux 1 "#f7768e"
    print_linux 2 "#9ece6a"
    print_linux 3 "#e0af68"
    print_linux 4 "#7aa2f7"
    print_linux 5 "#bb9af7"
    print_linux 6 "#7dcfff"
    print_linux 7 "#a9b1d6"
    print_linux 8 "#565f89"
    print_linux 9 "#f998aa"
    print_linux 10 "#add681"
    print_linux 11 "#e6bd83"
    print_linux 12 "#9dbaf9"
    print_linux 13 "#d4bffa"
    print_linux 14 "#a3ddff"
    print_linux 15 "#c0caf5"
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
