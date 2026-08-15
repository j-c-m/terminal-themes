#!/usr/bin/env bash

# The MIT License (MIT)
#
# Copyright (c) 2024 Sublime Text Packages
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# SPDX-License-Identifier: MIT
# Theme:    Spacegray Light
# Mode:     light
# Source:   Spacegray (https://github.com/SublimeText/Spacegray/)

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
    print_osc4 1 "c8/58/63"
    print_osc4 2 "6f/98/4c"
    print_osc4 3 "90/60/4f"
    print_osc4 4 "59/86/b6"
    print_osc4 5 "8b/5b/82"
    print_osc4 6 "5c/a8/a5"
    print_osc4 7 "c0/c5/ce"
    print_osc4 8 "65/73/7e"
    print_osc4 9 "cf/6e/77"
    print_osc4 10 "7a/a7/54"
    print_osc4 11 "eb/cb/8b"
    print_osc4 12 "6c/94/be"
    print_osc4 13 "99/64/8f"
    print_osc4 14 "6d/b1/ae"
    print_osc4 15 "ef/f1/f5"

    print_osc_rgb 10 "65/73/7e"
    print_osc_rgb 11 "df/e1/e8"
    print_osc_rgb 12 "65/73/7e"
    print_osc_rgb 17 "65/73/7e"
    print_osc_rgb 19 "df/e1/e8"
}

do_linux() {
    print_linux 0 "#343d46"
    print_linux 1 "#c85863"
    print_linux 2 "#6f984c"
    print_linux 3 "#90604f"
    print_linux 4 "#5986b6"
    print_linux 5 "#8b5b82"
    print_linux 6 "#5ca8a5"
    print_linux 7 "#c0c5ce"
    print_linux 8 "#65737e"
    print_linux 9 "#cf6e77"
    print_linux 10 "#7aa754"
    print_linux 11 "#ebcb8b"
    print_linux 12 "#6c94be"
    print_linux 13 "#99648f"
    print_linux 14 "#6db1ae"
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
