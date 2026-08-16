#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2021 Catppuccin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# SPDX-License-Identifier: MIT
# Theme:    Catppuccin Latte
# Mode:     light
# Source:   https://github.com/catppuccin/palette/blob/main/palette.json

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
    print_osc4 0 "5c/5f/77"
    print_osc4 1 "d2/0f/39"
    print_osc4 2 "40/a0/2b"
    print_osc4 3 "df/8e/1d"
    print_osc4 4 "1e/66/f5"
    print_osc4 5 "ea/76/cb"
    print_osc4 6 "17/92/99"
    print_osc4 7 "ac/b0/be"
    print_osc4 8 "6c/6f/85"
    print_osc4 9 "de/29/3e"
    print_osc4 10 "49/af/3d"
    print_osc4 11 "ee/a0/2d"
    print_osc4 12 "45/6e/ff"
    print_osc4 13 "fe/85/d8"
    print_osc4 14 "2d/9f/a8"
    print_osc4 15 "bc/c0/cc"

    print_osc_rgb 10 "4c/4f/69"
    print_osc_rgb 11 "ef/f1/f5"
    print_osc_rgb 12 "dc/8a/78"
    print_osc_rgb 17 "cc/d0/da"
    print_osc_rgb 19 "4c/4f/69"
}

do_linux() {
    print_linux 0 "#5c5f77"
    print_linux 1 "#d20f39"
    print_linux 2 "#40a02b"
    print_linux 3 "#df8e1d"
    print_linux 4 "#1e66f5"
    print_linux 5 "#ea76cb"
    print_linux 6 "#179299"
    print_linux 7 "#acb0be"
    print_linux 8 "#6c6f85"
    print_linux 9 "#de293e"
    print_linux 10 "#49af3d"
    print_linux 11 "#eea02d"
    print_linux 12 "#456eff"
    print_linux 13 "#fe85d8"
    print_linux 14 "#2d9fa8"
    print_linux 15 "#bcc0cc"
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
