#!/usr/bin/env bats

readonly cdr=$BATS_TEST_DIRNAME/../cdr
readonly tmpdir=$BATS_TEST_DIRNAME/../tmp
readonly stdout=$BATS_TEST_DIRNAME/../tmp/stdout
readonly stderr=$BATS_TEST_DIRNAME/../tmp/stderr
readonly exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  mkdir -p -- "$tmpdir"
}

teardown() {
  rm -rf -- "$tmpdir"
}

check() {
  printf "%s\n" "" > "$stdout"
  printf "%s\n" "" > "$stderr"
  printf "%s\n" "0" > "$exitcode"
  "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'cdr: print guidance to use cdr -w if no arguments passed' {
  check "$cdr"
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^"cdr: shell integration not enabled" ]]
}

@test 'cdr: print guidance to use cdr -w if double-dash passed' {
  check "$cdr" --
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^"cdr: shell integration not enabled" ]]
}

@test 'cdr: output guidance to use cdr --help if unknown option passed' {
  check "$cdr" --vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") != "" ]]
}

@test 'cdr: print guidance to use cdr -w if directory passed' {
  check "$cdr" some-directory
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^"cdr: shell integration not enabled" ]]
}

@test 'cdr: output guidance to use cdr -w if directory passed with double-dash' {
  check "$cdr" -- fn
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^'cdr: shell integration not enabled' ]]
}

# vim: ft=bash
