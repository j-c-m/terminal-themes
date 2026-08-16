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
# Theme:    Ayu Light
# Mode:     light
# Source:   https://github.com/ayu-theme/vscode-ayu/blob/master/ayu-dark.json https://github.com/ayu-theme/vscode-ayu/blob/master/ayu-light.json

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
    print_osc4 1 "f0/6b/6c"
    print_osc4 2 "6c/bf/43"
    print_osc4 3 "e7/a1/00"
    print_osc4 4 "21/a1/e2"
    print_osc4 5 "a1/76/cb"
    print_osc4 6 "4a/bc/96"
    print_osc4 7 "c7/c7/c7"
    print_osc4 8 "68/68/68"
    print_osc4 9 "f0/71/71"
    print_osc4 10 "86/b3/00"
    print_osc4 11 "eb/a4/00"
    print_osc4 12 "22/a4/e6"
    print_osc4 13 "a3/7a/cc"
    print_osc4 14 "4c/bf/99"
    print_osc4 15 "d1/d1/d1"

    print_osc_rgb 10 "5c/61/66"
    print_osc_rgb 11 "f8/f9/fa"
    print_osc_rgb 12 "f2/97/18"
    print_osc_rgb 17 "03/5b/d6"
    print_osc_rgb 19 "f8/f9/fa"
}

do_linux() {
    print_linux 0 "#000000"
    print_linux 1 "#f06b6c"
    print_linux 2 "#6cbf43"
    print_linux 3 "#e7a100"
    print_linux 4 "#21a1e2"
    print_linux 5 "#a176cb"
    print_linux 6 "#4abc96"
    print_linux 7 "#c7c7c7"
    print_linux 8 "#686868"
    print_linux 9 "#f07171"
    print_linux 10 "#86b300"
    print_linux 11 "#eba400"
    print_linux 12 "#22a4e6"
    print_linux 13 "#a37acc"
    print_linux 14 "#4cbf99"
    print_linux 15 "#d1d1d1"
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
