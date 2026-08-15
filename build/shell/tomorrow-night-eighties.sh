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
# Theme:    Tomorrow Night Eighties
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
    print_osc4 0 "39/39/39"
    print_osc4 1 "f2/77/7a"
    print_osc4 2 "99/cc/99"
    print_osc4 3 "a3/68/5a"
    print_osc4 4 "66/99/cc"
    print_osc4 5 "cc/99/cc"
    print_osc4 6 "66/cc/cc"
    print_osc4 7 "cc/cc/cc"
    print_osc4 8 "99/99/99"
    print_osc4 9 "f5/98/9a"
    print_osc4 10 "b1/d8/b1"
    print_osc4 11 "ff/cc/66"
    print_osc4 12 "7d/a8/d4"
    print_osc4 13 "d8/b1/d8"
    print_osc4 14 "7d/d4/d4"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "cc/cc/cc"
    print_osc_rgb 11 "2d/2d/2d"
    print_osc_rgb 12 "cc/cc/cc"
    print_osc_rgb 17 "cc/cc/cc"
    print_osc_rgb 19 "2d/2d/2d"
}

do_linux() {
    print_linux 0 "#393939"
    print_linux 1 "#f2777a"
    print_linux 2 "#99cc99"
    print_linux 3 "#a3685a"
    print_linux 4 "#6699cc"
    print_linux 5 "#cc99cc"
    print_linux 6 "#66cccc"
    print_linux 7 "#cccccc"
    print_linux 8 "#999999"
    print_linux 9 "#f5989a"
    print_linux 10 "#b1d8b1"
    print_linux 11 "#ffcc66"
    print_linux 12 "#7da8d4"
    print_linux 13 "#d8b1d8"
    print_linux 14 "#7dd4d4"
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
