#!/usr/bin/env bash

# Theme:    Rose Pine Moon
# Mode:     dark
# Source:   Rose Pine (https://github.com/rose-pine)

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
    print_osc4 0 "39/35/52"
    print_osc4 1 "eb/6f/92"
    print_osc4 2 "3e/8f/b0"
    print_osc4 3 "f6/c1/77"
    print_osc4 4 "9c/cf/d8"
    print_osc4 5 "c4/a7/e7"
    print_osc4 6 "ea/9a/97"
    print_osc4 7 "e0/de/f4"
    print_osc4 8 "6e/6a/86"
    print_osc4 9 "ef/8d/a9"
    print_osc4 10 "47/9c/be"
    print_osc4 11 "f8/d1/99"
    print_osc4 12 "b7/dc/e3"
    print_osc4 13 "d9/c6/f0"
    print_osc4 14 "f0/b9/b7"
    print_osc4 15 "e0/de/f4"

    print_osc_rgb 10 "e0/de/f4"
    print_osc_rgb 11 "23/21/36"
    print_osc_rgb 12 "56/52/6e"
    print_osc_rgb 17 "44/41/5a"
    print_osc_rgb 19 "e0/de/f4"
}

do_linux() {
    print_linux 0 "#393552"
    print_linux 1 "#eb6f92"
    print_linux 2 "#3e8fb0"
    print_linux 3 "#f6c177"
    print_linux 4 "#9ccfd8"
    print_linux 5 "#c4a7e7"
    print_linux 6 "#ea9a97"
    print_linux 7 "#e0def4"
    print_linux 8 "#6e6a86"
    print_linux 9 "#ef8da9"
    print_linux 10 "#479cbe"
    print_linux 11 "#f8d199"
    print_linux 12 "#b7dce3"
    print_linux 13 "#d9c6f0"
    print_linux 14 "#f0b9b7"
    print_linux 15 "#e0def4"
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
