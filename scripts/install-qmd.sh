#!/usr/bin/env bash
set -euo pipefail

PKG="@tobilu/qmd"
PREFIX="${NPM_CONFIG_PREFIX:-$HOME/.local}"

mkdir -p "$PREFIX"
export NPM_CONFIG_PREFIX="$PREFIX"
export PATH="$PREFIX/bin:$PATH"

printf 'Installing %s into %s\n' "$PKG" "$PREFIX"
npm install -g "$PKG"

printf '\nqmd location: '
command -v qmd
printf '\nqmd version/help check:\n'
qmd --help | sed -n '1,18p'
