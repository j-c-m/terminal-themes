#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2019 sainnhe
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
# Theme:    Everforest Dark Medium
# Mode:     dark
# Source:   https://github.com/sainnhe/everforest/blob/master/palette.md

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
    print_osc4 0 "2d/35/3b"
    print_osc4 1 "e6/7e/80"
    print_osc4 2 "a7/c0/80"
    print_osc4 3 "db/bc/7f"
    print_osc4 4 "7f/bb/b3"
    print_osc4 5 "d6/99/b6"
    print_osc4 6 "83/c0/92"
    print_osc4 7 "d3/c6/aa"
    print_osc4 8 "7a/84/78"
    print_osc4 9 "e6/7e/80"
    print_osc4 10 "a7/c0/80"
    print_osc4 11 "db/bc/7f"
    print_osc4 12 "7f/bb/b3"
    print_osc4 13 "d6/99/b6"
    print_osc4 14 "83/c0/92"
    print_osc4 15 "fd/f6/e3"

    print_osc_rgb 10 "d3/c6/aa"
    print_osc_rgb 11 "2d/35/3b"
    print_osc_rgb 12 "d3/c6/aa"
    print_osc_rgb 17 "d3/c6/aa"
    print_osc_rgb 19 "2d/35/3b"
}

do_linux() {
    print_linux 0 "#2d353b"
    print_linux 1 "#e67e80"
    print_linux 2 "#a7c080"
    print_linux 3 "#dbbc7f"
    print_linux 4 "#7fbbb3"
    print_linux 5 "#d699b6"
    print_linux 6 "#83c092"
    print_linux 7 "#d3c6aa"
    print_linux 8 "#7a8478"
    print_linux 9 "#e67e80"
    print_linux 10 "#a7c080"
    print_linux 11 "#dbbc7f"
    print_linux 12 "#7fbbb3"
    print_linux 13 "#d699b6"
    print_linux 14 "#83c092"
    print_linux 15 "#fdf6e3"
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
