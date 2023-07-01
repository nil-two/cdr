#!/usr/bin/env bats

readonly cdr=$BATS_TEST_DIRNAME/../cdr
readonly tmpdir=$BATS_TEST_DIRNAME/../tmp
readonly stdout=$BATS_TEST_DIRNAME/../tmp/stdout
readonly stderr=$BATS_TEST_DIRNAME/../tmp/stderr
readonly exitcode=$BATS_TEST_DIRNAME/../tmp/exitcode

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
  "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'cdr: change base direcotry if -b passed' {
  check "$cdr" -b"$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/BX/./BYC" ]]
}

@test 'cdr: change base direcotry if --base passed' {
  check "$cdr" --base "$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/BX/./BYC" ]]
}

@test 'cdr: change base direcotry if CDR_BASE set' {
  export CDR_BASE=$tmpdir/sub/BX
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/BX/./BYC" ]]
}

@test 'cdr: change filter command if -f passed' {
  check "$cdr" -f'sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./AX" ]]
}

@test 'cdr: change filter command if --filter passed' {
  check "$cdr" --filter 'sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./AX" ]]
}

@test 'cdr: change filter command if CDR_FILTER set' {
  CDR_FILTER='sed -n 2p'
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./AX" ]]
}

@test 'cdr: enable searching from Git managed directories if -g passed' {
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr" -g
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$(realpath "$tmpdir/sub/BX")" ]]
}

@test 'cdr: enable searching from Git managed directories if --git passed' {
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr" --git
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$(realpath "$tmpdir/sub/BX")" ]]
}

@test 'cdr: enable searching from Git managed directories if CDR_GIT set to true' {
  export CDR_GIT=true
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$(realpath "$tmpdir/sub/BX")" ]]
}

@test 'cdr: disable searching from Git managed directories if -G passed' {
  CDR_GIT=true
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr" -G
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./CX" ]]
}

@test 'cdr: disable searching from Git managed directories if --no-git passed' {
  CDR_GIT=true
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr" --no-git
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./CX" ]]
}

@test 'cdr: disable searching from Git managed directories if CDR_GIT set to not true' {
  CDR_GIT=false
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/./CX" ]]
}

@test 'cdr: change source command if -s passed' {
  check "$cdr" -s 'ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/CX" ]]
}

@test 'cdr: change source command if --source passed' {
  check "$cdr" --source 'ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/CX" ]]
}

@test 'cdr: change source command if CDR_SOURCE set' {
  CDR_SOURCE='ls'
  check "$cdr"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == "$tmpdir/sub/CX" ]]
}

@test 'cdr: output wrapper script if -w passed' {
  check "$cdr" -w sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: output wrapper script if --wrapper passed' {
  check "$cdr" --wrapper sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: print usage if --help passed' {
  check "$cdr" --help
  cat "$stdout"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"usage: cdr" ]]
}

# vim: ft=bash
