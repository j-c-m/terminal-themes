#!/usr/bin/env bash

# Theme:    Terafox
# Mode:     dark
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
    print_osc4 0 "2f/32/39"
    print_osc4 1 "e8/5c/51"
    print_osc4 2 "7a/a4/a1"
    print_osc4 3 "fd/a4/7f"
    print_osc4 4 "5a/93/aa"
    print_osc4 5 "ad/5c/7c"
    print_osc4 6 "a1/cd/d8"
    print_osc4 7 "eb/eb/eb"
    print_osc4 8 "4e/51/57"
    print_osc4 9 "eb/74/6b"
    print_osc4 10 "8e/b2/af"
    print_osc4 11 "fd/b2/92"
    print_osc4 12 "73/a3/b7"
    print_osc4 13 "b9/74/90"
    print_osc4 14 "af/d4/de"
    print_osc4 15 "ee/ee/ee"

    print_osc_rgb 10 "e6/ea/ea"
    print_osc_rgb 11 "15/25/28"
    print_osc_rgb 12 "e6/ea/ea"
    print_osc_rgb 17 "29/3e/40"
    print_osc_rgb 19 "e6/ea/ea"
}

do_linux() {
    print_linux 0 "#2f3239"
    print_linux 1 "#e85c51"
    print_linux 2 "#7aa4a1"
    print_linux 3 "#fda47f"
    print_linux 4 "#5a93aa"
    print_linux 5 "#ad5c7c"
    print_linux 6 "#a1cdd8"
    print_linux 7 "#ebebeb"
    print_linux 8 "#4e5157"
    print_linux 9 "#eb746b"
    print_linux 10 "#8eb2af"
    print_linux 11 "#fdb292"
    print_linux 12 "#73a3b7"
    print_linux 13 "#b97490"
    print_linux 14 "#afd4de"
    print_linux 15 "#eeeeee"
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
