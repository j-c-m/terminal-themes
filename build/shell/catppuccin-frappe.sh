#!/usr/bin/env bash

# Theme:    Catppuccin Frappe
# Mode:     dark
# Source:   Catppuccin (https://github.com/catppuccin/)
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
    print_osc4 0 "51/57/6d"
    print_osc4 1 "e7/82/84"
    print_osc4 2 "a6/d1/89"
    print_osc4 3 "e5/c8/90"
    print_osc4 4 "8c/aa/ee"
    print_osc4 5 "f4/b8/e4"
    print_osc4 6 "81/c8/be"
    print_osc4 7 "b5/bf/e2"
    print_osc4 8 "62/68/80"
    print_osc4 9 "ed/a0/a2"
    print_osc4 10 "b9/db/a2"
    print_osc4 11 "ec/d7/ae"
    print_osc4 12 "ad/c2/f3"
    print_osc4 13 "f3/8e/d8"
    print_osc4 14 "98/d2/ca"
    print_osc4 15 "a5/ad/ce"

    print_osc_rgb 10 "c6/d0/f5"
    print_osc_rgb 11 "30/34/46"
    print_osc_rgb 12 "f2/d5/cf"
    print_osc_rgb 17 "f2/d5/cf"
    print_osc_rgb 19 "30/34/46"
}

do_linux() {
    print_linux 0 "#51576d"
    print_linux 1 "#e78284"
    print_linux 2 "#a6d189"
    print_linux 3 "#e5c890"
    print_linux 4 "#8caaee"
    print_linux 5 "#f4b8e4"
    print_linux 6 "#81c8be"
    print_linux 7 "#b5bfe2"
    print_linux 8 "#626880"
    print_linux 9 "#eda0a2"
    print_linux 10 "#b9dba2"
    print_linux 11 "#ecd7ae"
    print_linux 12 "#adc2f3"
    print_linux 13 "#f38ed8"
    print_linux 14 "#98d2ca"
    print_linux 15 "#a5adce"
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
