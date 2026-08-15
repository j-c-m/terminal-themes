#!/usr/bin/env bash

# ISC License
#
# Copyright (c) 2016, Nathan Buchar
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# SPDX-License-Identifier: ISC
# Theme:    One Dark Dark
# Mode:     dark
# Source:   One Dark (https://github.com/nathanbuchar/atom-one-dark-terminal)

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
    print_osc4 0 "1e/21/27"
    print_osc4 1 "e0/6c/75"
    print_osc4 2 "98/c3/79"
    print_osc4 3 "d1/9a/66"
    print_osc4 4 "61/af/ef"
    print_osc4 5 "c6/78/dd"
    print_osc4 6 "56/b6/c2"
    print_osc4 7 "ab/b2/bf"
    print_osc4 8 "5c/63/70"
    print_osc4 9 "e6/87/8f"
    print_osc4 10 "a9/cd/8f"
    print_osc4 11 "d8/aa/7e"
    print_osc4 12 "80/be/f2"
    print_osc4 13 "d2/93/e4"
    print_osc4 14 "6b/bf/c9"
    print_osc4 15 "ff/ff/ff"

    print_osc_rgb 10 "ab/b2/bf"
    print_osc_rgb 11 "1e/21/27"
    print_osc_rgb 12 "5c/63/70"
    print_osc_rgb 17 "ab/b2/bf"
    print_osc_rgb 19 "1e/21/27"
}

do_linux() {
    print_linux 0 "#1e2127"
    print_linux 1 "#e06c75"
    print_linux 2 "#98c379"
    print_linux 3 "#d19a66"
    print_linux 4 "#61afef"
    print_linux 5 "#c678dd"
    print_linux 6 "#56b6c2"
    print_linux 7 "#abb2bf"
    print_linux 8 "#5c6370"
    print_linux 9 "#e6878f"
    print_linux 10 "#a9cd8f"
    print_linux 11 "#d8aa7e"
    print_linux 12 "#80bef2"
    print_linux 13 "#d293e4"
    print_linux 14 "#6bbfc9"
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
