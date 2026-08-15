#!/usr/bin/env bash

# Theme:    Dayfox
# Mode:     light
# Source:   Eden East (https://github.com/EdenEast/nightfox.nvim)
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
    print_osc4 0 "35/2c/24"
    print_osc4 1 "a5/22/2f"
    print_osc4 2 "39/68/47"
    print_osc4 3 "ac/54/02"
    print_osc4 4 "28/48/a9"
    print_osc4 5 "6e/33/ce"
    print_osc4 6 "28/79/80"
    print_osc4 7 "f2/e9/e1"
    print_osc4 8 "53/4c/45"
    print_osc4 9 "b3/43/4e"
    print_osc4 10 "57/7f/63"
    print_osc4 11 "b8/6e/28"
    print_osc4 12 "48/63/b6"
    print_osc4 13 "84/52/d5"
    print_osc4 14 "48/8d/93"
    print_osc4 15 "f4/ec/e6"

    print_osc_rgb 10 "3d/2b/5a"
    print_osc_rgb 11 "f6/f2/ee"
    print_osc_rgb 12 "3d/2b/5a"
    print_osc_rgb 17 "e7/d2/be"
    print_osc_rgb 19 "3d/2b/5a"
}

do_linux() {
    print_linux 0 "#352c24"
    print_linux 1 "#a5222f"
    print_linux 2 "#396847"
    print_linux 3 "#ac5402"
    print_linux 4 "#2848a9"
    print_linux 5 "#6e33ce"
    print_linux 6 "#287980"
    print_linux 7 "#f2e9e1"
    print_linux 8 "#534c45"
    print_linux 9 "#b3434e"
    print_linux 10 "#577f63"
    print_linux 11 "#b86e28"
    print_linux 12 "#4863b6"
    print_linux 13 "#8452d5"
    print_linux 14 "#488d93"
    print_linux 15 "#f4ece6"
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
