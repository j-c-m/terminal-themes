#!/usr/bin/env bash

# Theme:    {{theme-name}}
# Mode:     {{theme-mode}}
# Source:   {{theme-source}}

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
    print_osc4 0 "{{normal.black.hexterm}}"
    print_osc4 1 "{{normal.red.hexterm}}"
    print_osc4 2 "{{normal.green.hexterm}}"
    print_osc4 3 "{{normal.yellow.hexterm}}"
    print_osc4 4 "{{normal.blue.hexterm}}"
    print_osc4 5 "{{normal.magenta.hexterm}}"
    print_osc4 6 "{{normal.cyan.hexterm}}"
    print_osc4 7 "{{normal.white.hexterm}}"
    print_osc4 8 "{{bright.black.hexterm}}"
    print_osc4 9 "{{bright.red.hexterm}}"
    print_osc4 10 "{{bright.green.hexterm}}"
    print_osc4 11 "{{bright.yellow.hexterm}}"
    print_osc4 12 "{{bright.blue.hexterm}}"
    print_osc4 13 "{{bright.magenta.hexterm}}"
    print_osc4 14 "{{bright.cyan.hexterm}}"
    print_osc4 15 "{{bright.white.hexterm}}"

    print_osc_rgb 10 "{{foreground.hexterm}}"
    print_osc_rgb 11 "{{background.hexterm}}"
    print_osc_rgb 12 "{{cursor.hexterm}}"
    print_osc_rgb 17 "{{selection-background.hexterm}}"
    print_osc_rgb 19 "{{selection-foreground.hexterm}}"
}

do_linux() {
    print_linux 0 "{{normal.black.hex}}"
    print_linux 1 "{{normal.red.hex}}"
    print_linux 2 "{{normal.green.hex}}"
    print_linux 3 "{{normal.yellow.hex}}"
    print_linux 4 "{{normal.blue.hex}}"
    print_linux 5 "{{normal.magenta.hex}}"
    print_linux 6 "{{normal.cyan.hex}}"
    print_linux 7 "{{normal.white.hex}}"
    print_linux 8 "{{bright.black.hex}}"
    print_linux 9 "{{bright.red.hex}}"
    print_linux 10 "{{bright.green.hex}}"
    print_linux 11 "{{bright.yellow.hex}}"
    print_linux 12 "{{bright.blue.hex}}"
    print_linux 13 "{{bright.magenta.hex}}"
    print_linux 14 "{{bright.cyan.hex}}"
    print_linux 15 "{{bright.white.hex}}"
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
