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
# Theme:    Eighties Black
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
    print_osc4 0 "11/11/11"
    print_osc4 1 "ee/45/49"
    print_osc4 2 "59/b2/59"
    print_osc4 3 "c8/61/31"
    print_osc4 4 "37/73/af"
    print_osc4 5 "b2/59/b2"
    print_osc4 6 "37/af/af"
    print_osc4 7 "cc/cc/cc"
    print_osc4 8 "88/88/88"
    print_osc4 9 "f2/77/7a"
    print_osc4 10 "99/cc/99"
    print_osc4 11 "ff/cc/66"
    print_osc4 12 "66/99/cc"
    print_osc4 13 "cc/99/cc"
    print_osc4 14 "66/cc/cc"
    print_osc4 15 "f2/f0/ec"

    print_osc_rgb 10 "cc/cc/cc"
    print_osc_rgb 11 "00/00/00"
    print_osc_rgb 12 "cc/cc/cc"
    print_osc_rgb 17 "cc/cc/cc"
    print_osc_rgb 19 "00/00/00"
}

do_linux() {
    print_linux 0 "#111111"
    print_linux 1 "#ee4549"
    print_linux 2 "#59b259"
    print_linux 3 "#c86131"
    print_linux 4 "#3773af"
    print_linux 5 "#b259b2"
    print_linux 6 "#37afaf"
    print_linux 7 "#cccccc"
    print_linux 8 "#888888"
    print_linux 9 "#f2777a"
    print_linux 10 "#99cc99"
    print_linux 11 "#ffcc66"
    print_linux 12 "#6699cc"
    print_linux 13 "#cc99cc"
    print_linux 14 "#66cccc"
    print_linux 15 "#f2f0ec"
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
