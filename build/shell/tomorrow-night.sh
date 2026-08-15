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
# Theme:    Tomorrow Night
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
    print_osc4 0 "28/2a/2e"
    print_osc4 1 "cc/66/66"
    print_osc4 2 "b5/bd/68"
    print_osc4 3 "a3/68/5a"
    print_osc4 4 "81/a2/be"
    print_osc4 5 "b2/94/bb"
    print_osc4 6 "8a/be/b7"
    print_osc4 7 "c5/c8/c6"
    print_osc4 8 "96/98/96"
    print_osc4 9 "d4/7d/7d"
    print_osc4 10 "bf/c6/7c"
    print_osc4 11 "f0/c6/74"
    print_osc4 12 "96/b2/c9"
    print_osc4 13 "c1/a8/c8"
    print_osc4 14 "9f/ca/c4"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "c5/c8/c6"
    print_osc_rgb 11 "1d/1f/21"
    print_osc_rgb 12 "c5/c8/c6"
    print_osc_rgb 17 "c5/c8/c6"
    print_osc_rgb 19 "1d/1f/21"
}

do_linux() {
    print_linux 0 "#282a2e"
    print_linux 1 "#cc6666"
    print_linux 2 "#b5bd68"
    print_linux 3 "#a3685a"
    print_linux 4 "#81a2be"
    print_linux 5 "#b294bb"
    print_linux 6 "#8abeb7"
    print_linux 7 "#c5c8c6"
    print_linux 8 "#969896"
    print_linux 9 "#d47d7d"
    print_linux 10 "#bfc67c"
    print_linux 11 "#f0c674"
    print_linux 12 "#96b2c9"
    print_linux 13 "#c1a8c8"
    print_linux 14 "#9fcac4"
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
