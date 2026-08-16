#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2019 Robb Owen
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
# Theme:    Synthwave &#x27;84
# Mode:     dark
# Source:   Robb Owen (https://github.com/robb0wen/synthwave-vscode/)

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
    print_osc4 0 "00/00/00"
    print_osc4 1 "fe/44/50"
    print_osc4 2 "72/f1/b8"
    print_osc4 3 "f3/e7/0f"
    print_osc4 4 "03/ed/f9"
    print_osc4 5 "ff/7e/db"
    print_osc4 6 "03/ed/f9"
    print_osc4 7 "ee/ee/ee"
    print_osc4 8 "aa/aa/aa"
    print_osc4 9 "fe/44/50"
    print_osc4 10 "72/f1/b8"
    print_osc4 11 "fe/de/5d"
    print_osc4 12 "03/ed/f9"
    print_osc4 13 "ff/7e/db"
    print_osc4 14 "03/ed/f9"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "dd/dd/dd"
    print_osc_rgb 11 "26/23/35"
    print_osc_rgb 12 "03/ed/f9"
    print_osc_rgb 17 "ff/ff/ff"
    print_osc_rgb 19 "26/23/35"
}

do_linux() {
    print_linux 0 "#000000"
    print_linux 1 "#fe4450"
    print_linux 2 "#72f1b8"
    print_linux 3 "#f3e70f"
    print_linux 4 "#03edf9"
    print_linux 5 "#ff7edb"
    print_linux 6 "#03edf9"
    print_linux 7 "#eeeeee"
    print_linux 8 "#aaaaaa"
    print_linux 9 "#fe4450"
    print_linux 10 "#72f1b8"
    print_linux 11 "#fede5d"
    print_linux 12 "#03edf9"
    print_linux 13 "#ff7edb"
    print_linux 14 "#03edf9"
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
