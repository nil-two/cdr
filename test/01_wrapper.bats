#!/usr/bin/env bats

cmd=$BATS_TEST_DIRNAME/../cdr
tmpdir=$BATS_TEST_DIRNAME/../tmp
stdout=$BATS_TEST_DIRNAME/../tmp/stdout
stderr=$BATS_TEST_DIRNAME/../tmp/stderr
exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  export CDR_BASE=$tmpdir/sub
  export CDR_FILTER='tail -1'
  unset CDR_GIT
  export CDR_SOURCE='find -type d | sort'
  mkdir -p -- "$tmpdir/sub/"{AX,BX,CX} "$tmpdir/sub/BX/"{BYA,BYB,BYC}
}

teardown() {
  rm -rf -- "$tmpdir"
}

check() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  CMD=$cmd PATH="$PATH:$(dirname "$cmd")" "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'cdr wrapper: supports sh' {
  check sh -c 'eval "$("$CMD" -w sh)"; "$(basename "$CMD")"; pwd'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/sub/CX") ]]
}

@test 'cdr wrapper: supports bash' {
  check bash -c 'eval "$("$CMD" -w bash)"; "$(basename "$CMD")"; pwd'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/sub/CX") ]]
}

# vim: ft=bash
