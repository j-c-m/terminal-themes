#!/usr/bin/env bash

# Theme:    Night Owl Dark
# Mode:     dark
# Source:   Sarah Drasner (https://github.com/sdras/night-owl-vscode-theme)

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
    print_osc4 0 "01/16/27"
    print_osc4 1 "ef/53/50"
    print_osc4 2 "22/da/6e"
    print_osc4 3 "c5/e4/78"
    print_osc4 4 "82/aa/ff"
    print_osc4 5 "c7/92/ea"
    print_osc4 6 "21/c7/a8"
    print_osc4 7 "ff/ff/ff"
    print_osc4 8 "57/56/56"
    print_osc4 9 "f2/70/6d"
    print_osc4 10 "36/e0/7c"
    print_osc4 11 "ff/eb/95"
    print_osc4 12 "a9/c4/ff"
    print_osc4 13 "d7/b2/f0"
    print_osc4 14 "7f/db/ca"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "d6/de/eb"
    print_osc_rgb 11 "01/16/27"
    print_osc_rgb 12 "80/a4/c2"
    print_osc_rgb 17 "43/73/c2"
    print_osc_rgb 19 "01/16/27"
}

do_linux() {
    print_linux 0 "#011627"
    print_linux 1 "#ef5350"
    print_linux 2 "#22da6e"
    print_linux 3 "#c5e478"
    print_linux 4 "#82aaff"
    print_linux 5 "#c792ea"
    print_linux 6 "#21c7a8"
    print_linux 7 "#ffffff"
    print_linux 8 "#575656"
    print_linux 9 "#f2706d"
    print_linux 10 "#36e07c"
    print_linux 11 "#ffeb95"
    print_linux 12 "#a9c4ff"
    print_linux 13 "#d7b2f0"
    print_linux 14 "#7fdbca"
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
