#!/usr/bin/env bash

# Copyright (c) 2011 Ethan Schoonover
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# SPDX-License-Identifier: MIT
# Theme:    Solarized Dark
# Mode:     dark
# Source:   Solarized (https://github.com/altercation/solarized/)

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
    print_osc4 0 "07/36/42"
    print_osc4 1 "dc/32/2f"
    print_osc4 2 "85/99/00"
    print_osc4 3 "cb/4b/16"
    print_osc4 4 "26/8b/d2"
    print_osc4 5 "6c/71/c4"
    print_osc4 6 "2a/a1/98"
    print_osc4 7 "93/a1/a1"
    print_osc4 8 "58/6e/75"
    print_osc4 9 "e0/49/46"
    print_osc4 10 "92/a8/00"
    print_osc4 11 "b5/89/00"
    print_osc4 12 "36/97/db"
    print_osc4 13 "d3/36/82"
    print_osc4 14 "2e/b1/a7"
    print_osc4 15 "fd/f6/e3"

    print_osc_rgb 10 "83/94/96"
    print_osc_rgb 11 "00/2b/36"
    print_osc_rgb 12 "93/a1/a1"
    print_osc_rgb 17 "83/94/96"
    print_osc_rgb 19 "00/2b/36"
}

do_linux() {
    print_linux 0 "#073642"
    print_linux 1 "#dc322f"
    print_linux 2 "#859900"
    print_linux 3 "#cb4b16"
    print_linux 4 "#268bd2"
    print_linux 5 "#6c71c4"
    print_linux 6 "#2aa198"
    print_linux 7 "#93a1a1"
    print_linux 8 "#586e75"
    print_linux 9 "#e04946"
    print_linux 10 "#92a800"
    print_linux 11 "#b58900"
    print_linux 12 "#3697db"
    print_linux 13 "#d33682"
    print_linux 14 "#2eb1a7"
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
