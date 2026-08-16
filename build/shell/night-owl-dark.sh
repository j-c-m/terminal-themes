#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2018 Sarah Drasner
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
# Theme:    Night Owl Dark
# Mode:     dark
# Source:   Sarah Drasner (https://github.com/sdras/night-owl-vscode-theme)

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
    print_osc4 0 "01/16/27"
    print_osc4 1 "ef/53/50"
    print_osc4 2 "22/da/6e"
    print_osc4 3 "c5/e4/78"
    print_osc4 4 "82/aa/ff"
    print_osc4 5 "c7/92/ea"
    print_osc4 6 "21/c7/a8"
    print_osc4 7 "ff/ff/ff"
    print_osc4 8 "57/56/56"
    print_osc4 9 "ef/53/50"
    print_osc4 10 "22/da/6e"
    print_osc4 11 "ff/eb/95"
    print_osc4 12 "82/aa/ff"
    print_osc4 13 "c7/92/ea"
    print_osc4 14 "7f/db/ca"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "d6/de/eb"
    print_osc_rgb 11 "01/16/27"
    print_osc_rgb 12 "80/a4/c2"
    print_osc_rgb 17 "43/73/c2"
    print_osc_rgb 19 "01/16/27"
}

do_linux() {
    print_linux 0 "#011627"
    print_linux 1 "#ef5350"
    print_linux 2 "#22da6e"
    print_linux 3 "#c5e478"
    print_linux 4 "#82aaff"
    print_linux 5 "#c792ea"
    print_linux 6 "#21c7a8"
    print_linux 7 "#ffffff"
    print_linux 8 "#575656"
    print_linux 9 "#ef5350"
    print_linux 10 "#22da6e"
    print_linux 11 "#ffeb95"
    print_linux 12 "#82aaff"
    print_linux 13 "#c792ea"
    print_linux 14 "#7fdbca"
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
