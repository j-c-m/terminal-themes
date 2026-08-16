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
# Theme:    Ayu Dark
# Mode:     dark
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
    print_osc4 0 "1b/1f/29"
    print_osc4 1 "f0/6b/73"
    print_osc4 2 "70/bf/56"
    print_osc4 3 "fd/b0/4c"
    print_osc4 4 "4f/bf/ff"
    print_osc4 5 "d0/a1/ff"
    print_osc4 6 "93/e2/c8"
    print_osc4 7 "c7/c7/c7"
    print_osc4 8 "68/68/68"
    print_osc4 9 "f0/71/78"
    print_osc4 10 "aa/d9/4c"
    print_osc4 11 "ff/b4/54"
    print_osc4 12 "59/c2/ff"
    print_osc4 13 "d2/a6/ff"
    print_osc4 14 "95/e6/cb"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "bf/bd/b6"
    print_osc_rgb 11 "0d/10/17"
    print_osc_rgb 12 "e6/b4/50"
    print_osc_rgb 17 "33/88/ff"
    print_osc_rgb 19 "0d/10/17"
}

do_linux() {
    print_linux 0 "#1b1f29"
    print_linux 1 "#f06b73"
    print_linux 2 "#70bf56"
    print_linux 3 "#fdb04c"
    print_linux 4 "#4fbfff"
    print_linux 5 "#d0a1ff"
    print_linux 6 "#93e2c8"
    print_linux 7 "#c7c7c7"
    print_linux 8 "#686868"
    print_linux 9 "#f07178"
    print_linux 10 "#aad94c"
    print_linux 11 "#ffb454"
    print_linux 12 "#59c2ff"
    print_linux 13 "#d2a6ff"
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
