#!/usr/bin/env bash

# The MIT License (MIT)
#
# Copyright (c) 2016 Romain Lafourcade
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
# Theme:    Apprentice
# Mode:     dark
# Source:   (https://github.com/romainl/Apprentice)

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
    print_osc4 0 "1c/1c/1c"
    print_osc4 1 "af/5f/5f"
    print_osc4 2 "5f/87/5f"
    print_osc4 3 "87/87/5f"
    print_osc4 4 "5f/87/af"
    print_osc4 5 "5f/5f/87"
    print_osc4 6 "5f/87/87"
    print_osc4 7 "6c/6c/6c"
    print_osc4 8 "44/44/44"
    print_osc4 9 "ff/87/00"
    print_osc4 10 "87/af/87"
    print_osc4 11 "ff/ff/af"
    print_osc4 12 "87/af/d7"
    print_osc4 13 "87/87/af"
    print_osc4 14 "5f/af/af"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "bc/bc/bc"
    print_osc_rgb 11 "26/26/26"
    print_osc_rgb 12 "bc/bc/bc"
    print_osc_rgb 17 "bc/bc/bc"
    print_osc_rgb 19 "26/26/26"
}

do_linux() {
    print_linux 0 "#1c1c1c"
    print_linux 1 "#af5f5f"
    print_linux 2 "#5f875f"
    print_linux 3 "#87875f"
    print_linux 4 "#5f87af"
    print_linux 5 "#5f5f87"
    print_linux 6 "#5f8787"
    print_linux 7 "#6c6c6c"
    print_linux 8 "#444444"
    print_linux 9 "#ff8700"
    print_linux 10 "#87af87"
    print_linux 11 "#ffffaf"
    print_linux 12 "#87afd7"
    print_linux 13 "#8787af"
    print_linux 14 "#5fafaf"
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
