#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2016 Ike Ku
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
# Theme:    Ayu Mirage
# Mode:     dark
# Source:   Ayu Theme (https://github.com/ayu-theme)

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
    print_osc4 0 "17/1b/24"
    print_osc4 1 "ed/82/74"
    print_osc4 2 "87/d9/6c"
    print_osc4 3 "fa/cc/6e"
    print_osc4 4 "6d/cb/fa"
    print_osc4 5 "da/ba/fa"
    print_osc4 6 "90/e1/c6"
    print_osc4 7 "c7/c7/c7"
    print_osc4 8 "68/68/68"
    print_osc4 9 "f2/87/79"
    print_osc4 10 "d5/ff/80"
    print_osc4 11 "ff/d1/73"
    print_osc4 12 "73/d0/ff"
    print_osc4 13 "df/bf/ff"
    print_osc4 14 "95/e6/cb"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "cc/ca/c2"
    print_osc_rgb 11 "1f/24/30"
    print_osc_rgb 12 "ff/cc/66"
    print_osc_rgb 17 "40/9f/ff"
    print_osc_rgb 19 "1f/24/30"
}

do_linux() {
    print_linux 0 "#171b24"
    print_linux 1 "#ed8274"
    print_linux 2 "#87d96c"
    print_linux 3 "#facc6e"
    print_linux 4 "#6dcbfa"
    print_linux 5 "#dabafa"
    print_linux 6 "#90e1c6"
    print_linux 7 "#c7c7c7"
    print_linux 8 "#686868"
    print_linux 9 "#f28779"
    print_linux 10 "#d5ff80"
    print_linux 11 "#ffd173"
    print_linux 12 "#73d0ff"
    print_linux 13 "#dfbfff"
    print_linux 14 "#95e6cb"
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
