#!/usr/bin/env bats

readonly cdr=$BATS_TEST_DIRNAME/../cdr
readonly tmpdir=$BATS_TEST_DIRNAME/../tmp
readonly stdout=$BATS_TEST_DIRNAME/../tmp/stdout
readonly stderr=$BATS_TEST_DIRNAME/../tmp/stderr
readonly exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

setup() {
  unset CDR_BASE
  export CDR_FILTER='tail -1'
  unset CDR_GIT
  export CDR_SOURCE='echo A; echo B; echo C'
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

@test 'cdr: print a selected directory without chdir if no arguments passed' {
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == C ]]
}

@test 'cdr: print a selected directory without chdir if double-dash passed' {
  check "$cdr" --
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == C ]]
}

@test 'cdr: output error if unknown option passed' {
  check "$cdr" --vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") != "" ]]
}

@test 'cdr: print the directory without chdir if directory passed' {
  mkdir "$tmpdir/sub"
  check "$cdr" "$tmpdir/sub"
  cat "$stdout"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub ]]
}

@test 'cdr: print the directory without chdir if directory passed with double-dash' {
  mkdir "$tmpdir/sub"
  check "$cdr" -- "$tmpdir/sub"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub ]]
}

# vim: ft=bash
