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
# Theme:    Mocha
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
    print_osc4 0 "53/46/36"
    print_osc4 1 "cb/60/77"
    print_osc4 2 "be/b5/5b"
    print_osc4 3 "bb/95/84"
    print_osc4 4 "8a/b3/b5"
    print_osc4 5 "a8/9b/b9"
    print_osc4 6 "7b/bd/a4"
    print_osc4 7 "d0/c8/c6"
    print_osc4 8 "7e/70/5a"
    print_osc4 9 "cb/60/77"
    print_osc4 10 "be/b5/5b"
    print_osc4 11 "f4/bc/87"
    print_osc4 12 "8a/b3/b5"
    print_osc4 13 "a8/9b/b9"
    print_osc4 14 "7b/bd/a4"
    print_osc4 15 "f5/ee/eb"

    print_osc_rgb 10 "d0/c8/c6"
    print_osc_rgb 11 "3b/32/28"
    print_osc_rgb 12 "d0/c8/c6"
    print_osc_rgb 17 "d0/c8/c6"
    print_osc_rgb 19 "3b/32/28"
}

do_linux() {
    print_linux 0 "#534636"
    print_linux 1 "#cb6077"
    print_linux 2 "#beb55b"
    print_linux 3 "#bb9584"
    print_linux 4 "#8ab3b5"
    print_linux 5 "#a89bb9"
    print_linux 6 "#7bbda4"
    print_linux 7 "#d0c8c6"
    print_linux 8 "#7e705a"
    print_linux 9 "#cb6077"
    print_linux 10 "#beb55b"
    print_linux 11 "#f4bc87"
    print_linux 12 "#8ab3b5"
    print_linux 13 "#a89bb9"
    print_linux 14 "#7bbda4"
    print_linux 15 "#f5eeeb"
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
