#!/usr/bin/env bash

# MIT License (MIT)
#
# Copyright (c) 2016-present Sven Greb <development@svengreb.de> (https://www.svengreb.de)
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
# Theme:    Nord
# Mode:     dark
# Source:   Nord (https://www.nordtheme.com/)

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
    print_osc4 0 "3b/42/52"
    print_osc4 1 "bf/61/6a"
    print_osc4 2 "a3/be/8c"
    print_osc4 3 "d0/87/70"
    print_osc4 4 "81/a1/c1"
    print_osc4 5 "b4/8e/ad"
    print_osc4 6 "88/c0/d0"
    print_osc4 7 "e5/e9/f0"
    print_osc4 8 "4c/56/6a"
    print_osc4 9 "bf/61/6a"
    print_osc4 10 "a3/be/8c"
    print_osc4 11 "eb/cb/8b"
    print_osc4 12 "81/a1/c1"
    print_osc4 13 "b4/8e/ad"
    print_osc4 14 "8f/bc/bb"
    print_osc4 15 "ec/ef/f4"

    print_osc_rgb 10 "d8/de/e9"
    print_osc_rgb 11 "2e/34/40"
    print_osc_rgb 12 "d8/de/e9"
    print_osc_rgb 17 "4c/56/6a"
    print_osc_rgb 19 "d8/de/e9"
}

do_linux() {
    print_linux 0 "#3b4252"
    print_linux 1 "#bf616a"
    print_linux 2 "#a3be8c"
    print_linux 3 "#d08770"
    print_linux 4 "#81a1c1"
    print_linux 5 "#b48ead"
    print_linux 6 "#88c0d0"
    print_linux 7 "#e5e9f0"
    print_linux 8 "#4c566a"
    print_linux 9 "#bf616a"
    print_linux 10 "#a3be8c"
    print_linux 11 "#ebcb8b"
    print_linux 12 "#81a1c1"
    print_linux 13 "#b48ead"
    print_linux 14 "#8fbcbb"
    print_linux 15 "#eceff4"
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
