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
# Theme:    Tomorrow
# Mode:     light
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
    print_osc4 0 "e0/e0/e0"
    print_osc4 1 "c8/28/29"
    print_osc4 2 "71/8c/00"
    print_osc4 3 "a3/68/5a"
    print_osc4 4 "42/71/ae"
    print_osc4 5 "89/59/a8"
    print_osc4 6 "3e/99/9f"
    print_osc4 7 "37/3b/41"
    print_osc4 8 "b4/b7/b4"
    print_osc4 9 "d6/32/33"
    print_osc4 10 "7c/9a/00"
    print_osc4 11 "ea/b7/00"
    print_osc4 12 "4d/7d/bb"
    print_osc4 13 "95/6a/b1"
    print_osc4 14 "44/a8/af"
    print_osc4 15 "1d/1f/21"

    print_osc_rgb 10 "37/3b/41"
    print_osc_rgb 11 "ff/ff/ff"
    print_osc_rgb 12 "37/3b/41"
    print_osc_rgb 17 "37/3b/41"
    print_osc_rgb 19 "ff/ff/ff"
}

do_linux() {
    print_linux 0 "#e0e0e0"
    print_linux 1 "#c82829"
    print_linux 2 "#718c00"
    print_linux 3 "#a3685a"
    print_linux 4 "#4271ae"
    print_linux 5 "#8959a8"
    print_linux 6 "#3e999f"
    print_linux 7 "#373b41"
    print_linux 8 "#b4b7b4"
    print_linux 9 "#d63233"
    print_linux 10 "#7c9a00"
    print_linux 11 "#eab700"
    print_linux 12 "#4d7dbb"
    print_linux 13 "#956ab1"
    print_linux 14 "#44a8af"
    print_linux 15 "#1d1f21"
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
