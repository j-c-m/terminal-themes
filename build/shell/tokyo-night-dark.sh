#!/usr/bin/env bash

# The MIT License (MIT)
#
# Copyright (c) 2018-present Enkia
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
# Theme:    Tokyo Night Dark
# Mode:     dark
# Source:   Tokyo Night (https://github.com/tokyo-night/)

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
    print_osc4 0 "41/48/68"
    print_osc4 1 "f7/76/8e"
    print_osc4 2 "9e/ce/6a"
    print_osc4 3 "e0/af/68"
    print_osc4 4 "7a/a2/f7"
    print_osc4 5 "bb/9a/f7"
    print_osc4 6 "7d/cf/ff"
    print_osc4 7 "a9/b1/d6"
    print_osc4 8 "56/5f/89"
    print_osc4 9 "f7/76/8e"
    print_osc4 10 "9e/ce/6a"
    print_osc4 11 "e0/af/68"
    print_osc4 12 "7a/a2/f7"
    print_osc4 13 "bb/9a/f7"
    print_osc4 14 "7d/cf/ff"
    print_osc4 15 "c0/ca/f5"

    print_osc_rgb 10 "a9/b1/d6"
    print_osc_rgb 11 "1a/1b/26"
    print_osc_rgb 12 "a9/b1/d6"
    print_osc_rgb 17 "a9/b1/d6"
    print_osc_rgb 19 "1a/1b/26"
}

do_linux() {
    print_linux 0 "#414868"
    print_linux 1 "#f7768e"
    print_linux 2 "#9ece6a"
    print_linux 3 "#e0af68"
    print_linux 4 "#7aa2f7"
    print_linux 5 "#bb9af7"
    print_linux 6 "#7dcfff"
    print_linux 7 "#a9b1d6"
    print_linux 8 "#565f89"
    print_linux 9 "#f7768e"
    print_linux 10 "#9ece6a"
    print_linux 11 "#e0af68"
    print_linux 12 "#7aa2f7"
    print_linux 13 "#bb9af7"
    print_linux 14 "#7dcfff"
    print_linux 15 "#c0caf5"
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
