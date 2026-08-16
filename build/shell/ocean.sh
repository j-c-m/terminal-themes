#!/usr/bin/env bash

# MIT License
#
# Copyright (C) 2012 Chris Kempson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# SPDX-License-Identifier: MIT
# Theme:    Ocean
# Mode:     dark
# Source:   Chris Kempson (http://chriskempson.com)

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
    print_osc4 0 "34/3d/46"
    print_osc4 1 "bf/61/6a"
    print_osc4 2 "a3/be/8c"
    print_osc4 3 "ab/79/67"
    print_osc4 4 "8f/a1/b3"
    print_osc4 5 "b4/8e/ad"
    print_osc4 6 "96/b5/b4"
    print_osc4 7 "c0/c5/ce"
    print_osc4 8 "65/73/7e"
    print_osc4 9 "c7/75/7d"
    print_osc4 10 "b4/ca/a1"
    print_osc4 11 "eb/cb/8b"
    print_osc4 12 "a2/b1/c0"
    print_osc4 13 "c1/a1/bb"
    print_osc4 14 "a9/c3/c2"
    print_osc4 15 "ef/f1/f5"

    print_osc_rgb 10 "c0/c5/ce"
    print_osc_rgb 11 "2b/30/3b"
    print_osc_rgb 12 "c0/c5/ce"
    print_osc_rgb 17 "c0/c5/ce"
    print_osc_rgb 19 "2b/30/3b"
}

do_linux() {
    print_linux 0 "#343d46"
    print_linux 1 "#bf616a"
    print_linux 2 "#a3be8c"
    print_linux 3 "#ab7967"
    print_linux 4 "#8fa1b3"
    print_linux 5 "#b48ead"
    print_linux 6 "#96b5b4"
    print_linux 7 "#c0c5ce"
    print_linux 8 "#65737e"
    print_linux 9 "#c7757d"
    print_linux 10 "#b4caa1"
    print_linux 11 "#ebcb8b"
    print_linux 12 "#a2b1c0"
    print_linux 13 "#c1a1bb"
    print_linux 14 "#a9c3c2"
    print_linux 15 "#eff1f5"
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
