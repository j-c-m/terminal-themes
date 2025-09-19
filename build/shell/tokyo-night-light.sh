#!/usr/bin/env bash

# Theme:    Tokyo Night Light
# Mode:     light
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
    print_osc4 0 "34/3b/58"
    print_osc4 1 "8c/43/51"
    print_osc4 2 "38/5f/0d"
    print_osc4 3 "8f/5e/15"
    print_osc4 4 "29/59/aa"
    print_osc4 5 "5a/3e/8e"
    print_osc4 6 "0f/4b/6e"
    print_osc4 7 "34/3b/58"
    print_osc4 8 "6c/6e/75"
    print_osc4 9 "9a/4a/59"
    print_osc4 10 "3e/69/0e"
    print_osc4 11 "9d/67/17"
    print_osc4 12 "2d/62/bb"
    print_osc4 13 "63/44/9c"
    print_osc4 14 "10/52/79"
    print_osc4 15 "34/3b/58"

    print_osc_rgb 10 "34/3b/58"
    print_osc_rgb 11 "e6/e7/ed"
    print_osc_rgb 12 "34/3b/58"
    print_osc_rgb 17 "34/3b/58"
    print_osc_rgb 19 "e6/e7/ed"
}

do_linux() {
    print_linux 0 "#343b58"
    print_linux 1 "#8c4351"
    print_linux 2 "#385f0d"
    print_linux 3 "#8f5e15"
    print_linux 4 "#2959aa"
    print_linux 5 "#5a3e8e"
    print_linux 6 "#0f4b6e"
    print_linux 7 "#343b58"
    print_linux 8 "#6c6e75"
    print_linux 9 "#9a4a59"
    print_linux 10 "#3e690e"
    print_linux 11 "#9d6717"
    print_linux 12 "#2d62bb"
    print_linux 13 "#63449c"
    print_linux 14 "#105279"
    print_linux 15 "#343b58"
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
