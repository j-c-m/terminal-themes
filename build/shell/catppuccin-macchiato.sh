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
# Theme:    Catppuccin Macchiato
# Mode:     dark
# Source:   Catppuccin (https://github.com/catppuccin/)

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
    print_osc4 0 "49/4d/64"
    print_osc4 1 "ed/87/96"
    print_osc4 2 "a6/da/95"
    print_osc4 3 "ee/d4/9f"
    print_osc4 4 "8a/ad/f4"
    print_osc4 5 "f5/bd/e6"
    print_osc4 6 "8b/d5/ca"
    print_osc4 7 "b8/c0/e0"
    print_osc4 8 "5b/60/78"
    print_osc4 9 "ed/87/96"
    print_osc4 10 "a6/da/95"
    print_osc4 11 "ee/d4/9f"
    print_osc4 12 "8a/ad/f4"
    print_osc4 13 "f5/bd/e6"
    print_osc4 14 "8b/d5/ca"
    print_osc4 15 "a5/ad/cb"

    print_osc_rgb 10 "ca/d3/f5"
    print_osc_rgb 11 "24/27/3a"
    print_osc_rgb 12 "f4/db/d6"
    print_osc_rgb 17 "f4/db/d6"
    print_osc_rgb 19 "24/27/3a"
}

do_linux() {
    print_linux 0 "#494d64"
    print_linux 1 "#ed8796"
    print_linux 2 "#a6da95"
    print_linux 3 "#eed49f"
    print_linux 4 "#8aadf4"
    print_linux 5 "#f5bde6"
    print_linux 6 "#8bd5ca"
    print_linux 7 "#b8c0e0"
    print_linux 8 "#5b6078"
    print_linux 9 "#ed8796"
    print_linux 10 "#a6da95"
    print_linux 11 "#eed49f"
    print_linux 12 "#8aadf4"
    print_linux 13 "#f5bde6"
    print_linux 14 "#8bd5ca"
    print_linux 15 "#a5adcb"
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
