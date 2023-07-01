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
  "$@" > "$stdout" 2> "$stderr" || printf "%s\n" "$?" > "$exitcode"
}

@test 'cdr: print a selected directory without chdir if no arguments passed' {
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./CX ]]
}

@test 'cdr: print a selected directory without chdir if double-dash passed' {
  check "$cmd" --
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./CX ]]
}

@test 'cdr: print error if unknown option passed' {
  check "$cmd" --vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") != "" ]]
}

@test 'cdr: change base directory if -b directory passed' {
  check "$cmd" -b "$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/BX/./BYC ]]
}

@test 'cdr: change base directory if -bdirectory passed' {
  check "$cmd" -b"$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/BX/./BYC ]]
}

@test 'cdr: change base directory if --base directory passed' {
  check "$cmd" --base "$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/BX/./BYC ]]
}

@test 'cdr: change base directory if --base=directory passed' {
  check "$cmd" --base="$tmpdir/sub/BX"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/BX/./BYC ]]
}

@test 'cdr: change filter command if -f command passed' {
  check "$cmd" -f 'sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./AX ]]
}

@test 'cdr: change filter command if -fcommand passed' {
  check "$cmd" -f'sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./AX ]]
}

@test 'cdr: change filter command if --filter command passed' {
  check "$cmd" --filter 'sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./AX ]]
}

@test 'cdr: change filter command if --filter=command passed' {
  check "$cmd" --filter='sed -n 2p'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./AX ]]
}

@test 'cdr: enable searching from Git managed directories if -g passed' {
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cmd" -g
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/sub/BX") ]]
}

@test 'cdr: enable searching from Git managed directories if --git passed' {
  cd "$tmpdir/sub"
  git init > /dev/null 2>&1 || true
  git config user.name "test"
  git config user.email "test@example.com"
  touch "$tmpdir/sub/BX/FA"
  git add "$tmpdir/sub/BX/FA"
  git commit -m test > /dev/null
  check "$cmd" --git
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/sub/BX") ]]
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
  check "$cmd" -G
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./CX ]]
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
  check "$cmd" --no-git
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./CX ]]
}

@test 'cdr: change source command if -s command passed' {
  check "$cmd" -s 'ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/CX ]]
}

@test 'cdr: change source command if -scommand passed' {
  check "$cmd" -s'ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/CX ]]
}

@test 'cdr: change source command if --source command passed' {
  check "$cmd" --source 'ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/CX ]]
}

@test 'cdr: change source command if --source=command passed' {
  check "$cmd" --source='ls'
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/CX ]]
}

@test 'cdr: print wrapper script if -w shell passed' {
  check "$cmd" -w sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: print wrapper script if -wshell passed' {
  check "$cmd" -wsh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: print wrapper script if --wrapper sh passed' {
  check "$cmd" --wrapper sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: print wrapper script if --wrapper=shell passed' {
  check "$cmd" --wrapper=sh
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"cdr() {" ]]
}

@test 'cdr: print error if --wrapper unsupported-shell passed' {
  check "$cmd" --wrapper vim
  [[ $(cat "$exitcode") == 1 ]]
  [[ $(cat "$stderr") =~ ^'cdr: unsupported shell' ]]
}

@test 'cdr: print usage if --help passed' {
  check "$cmd" --help
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") =~ ^"usage: cdr" ]]
}

@test 'cdr: print the directory without chdir if directory passed' {
  check "$cmd" "$tmpdir/sub"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub ]]
}

@test 'cdr: change base directory if CDR_BASE set' {
  export CDR_BASE=$tmpdir/sub/BX
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/BX/./BYC ]]
}

@test 'cdr: change filter command if CDR_FILTER set' {
  CDR_FILTER='sed -n 2p'
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./AX ]]
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
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $(realpath "$tmpdir/sub/BX") ]]
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
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/./CX ]]
}

@test 'cdr: change source command if CDR_SOURCE set' {
  CDR_SOURCE='ls'
  check "$cmd"
  [[ $(cat "$exitcode") == 0 ]]
  [[ $(cat "$stdout") == $tmpdir/sub/CX ]]
}

# vim: ft=bash
