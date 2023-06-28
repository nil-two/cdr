#!/bin/bash
set -eu

cd -- "$(dirname "$(readlink -f "$0")")/.."

target_file=cdr
argparse_src_marker_start='# src:argparse:start'
argparse_src_marker_end='# src:argparse:end'
argparse_dst_marker_start='# dst:argparse:start'
argparse_dst_marker_end='# dst:argparse:end'

argparse_file=$(mktemp "/tmp/${0##*/}.tmp.XXXXXX")
atexit() {
	rm -f -- "$argparse_file"
}
trap "atexit" EXIT

cat "$target_file" \
  | sed -ne '/'"$argparse_src_marker_start"'/,/'"$argparse_src_marker_end"'/p' \
  | sed -e '1d' \
        -e '$d' \
        -e 's/^/  /g' \
        -e 's/\$/\\$/g' \
        -e 's/^\(  \)\([a-z_]*=\)/\1local \2/g' \
        -e 's/^\( *\)exit /\1return /g' \
        -e 's/^\( *\)print_usage$/\1command cdr --help/g' \
        -e 's/^\( *\)print_wrapper_script/\1command cdr --wrapper/g' \
  | sed -e '1i\  '"$argparse_dst_marker_start"'' \
        -e '$a\  '"$argparse_dst_marker_end"'' \
  > "$argparse_file"

sed -i \
  -e '/'"$argparse_dst_marker_start"'/r '"$argparse_file"'' \
  -e '/'"$argparse_dst_marker_start"'/,/'"$argparse_dst_marker_end"'/d' \
  "$target_file"
