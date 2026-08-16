#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2023 Rosé Pine
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
# Theme:    Rose Pine
# Mode:     dark
# Source:   Rose Pine (https://github.com/rose-pine)

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
    print_osc4 0 "26/23/3a"
    print_osc4 1 "eb/6f/92"
    print_osc4 2 "31/74/8f"
    print_osc4 3 "f6/c1/77"
    print_osc4 4 "9c/cf/d8"
    print_osc4 5 "c4/a7/e7"
    print_osc4 6 "eb/bc/ba"
    print_osc4 7 "e0/de/f4"
    print_osc4 8 "6e/6a/86"
    print_osc4 9 "eb/6f/92"
    print_osc4 10 "31/74/8f"
    print_osc4 11 "f6/c1/77"
    print_osc4 12 "9c/cf/d8"
    print_osc4 13 "c4/a7/e7"
    print_osc4 14 "eb/bc/ba"
    print_osc4 15 "e0/de/f4"

    print_osc_rgb 10 "e0/de/f4"
    print_osc_rgb 11 "19/17/24"
    print_osc_rgb 12 "52/4f/67"
    print_osc_rgb 17 "40/3d/52"
    print_osc_rgb 19 "e0/de/f4"
}

do_linux() {
    print_linux 0 "#26233a"
    print_linux 1 "#eb6f92"
    print_linux 2 "#31748f"
    print_linux 3 "#f6c177"
    print_linux 4 "#9ccfd8"
    print_linux 5 "#c4a7e7"
    print_linux 6 "#ebbcba"
    print_linux 7 "#e0def4"
    print_linux 8 "#6e6a86"
    print_linux 9 "#eb6f92"
    print_linux 10 "#31748f"
    print_linux 11 "#f6c177"
    print_linux 12 "#9ccfd8"
    print_linux 13 "#c4a7e7"
    print_linux 14 "#ebbcba"
    print_linux 15 "#e0def4"
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
