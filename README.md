cdr
===

[![CI](https://github.com/nil-two/cdr/actions/workflows/test.yml/badge.svg)](https://github.com/nil-two/cdr/actions/workflows/test.yml)

Chdir with recursive directory searching.

```
$ pwd
/path
$ cdr
(Select a directory from directories under the current directory, and chdir to the directory (e.g. Select to/directory))

$ pwd
/path/to/directory
```

Usage
-----

```
usage: cdr [<option(s)>] [<directory>]
chdir with recursive directory searching.

options:
  -b, --base=<directory>  use the directory as the base directory
  -f, --filter=<command>  use the command to select a directory
  -g, --git               enable searching from Git managed directories
  -G, --no-git            disable searching from Git managed directories
  -s, --source=<command>  use the command to list directories
  -w, --wrapper=<shell>   output the wrapper script for the shell and exit
      --help              print usage and exit
  [<directory>]           chdir to the directory without selecting

supported-shells:
  sh, bash, zsh, yash, fish

environment-variables:
  CDR_BASE    set default -b/--base
  CDR_FILTER  set default -f/--filter (default: percol)
  CDR_GIT     set default -g/--git (default: false)
  CDR_SOURCE  set default -s/--source (default: find -type d)
```

Requirements
------------

- sh
- find
- Percol (If you use default `CDR_FILTER`)
- Git (If you use -g, --git option)

Installation
------------

1. Copy `cdr` into your `$PATH`.
2. Make `cdr` executable.
3. Add the following config to your shell's profile.

| Shell |                              |
|-------|------------------------------|
| sh    | eval "$(cdr -w sh)"          |
| bash  | eval "$(cdr -w bash)"        |
| zsh   | eval "$(cdr -w zsh)"         |
| yash  | eval "$(cdr -w yash)"        |
| fish  | source (cdr -w fish \| psub) |

### Example

```
$ curl -L https://raw.githubusercontent.com/nil-two/cdr/master/cdr > ~/bin/cdr
$ chmod +x ~/bin/cdr
$ echo 'eval "$(cdr -w bash)"' >> ~/.bashrc
```

Note: In this example, `$HOME/bin` must be included in `$PATH`.

Options
-------

### -b, --base=\<directory\>

Use the `directory` as the base directory,
and add a candidate of the base directory.
The default value is the value of `CDR_BASE` or none.
This option takes precedence over `CDR_BASE`.

```
$ cdr -b/etc/nginx
(Use /etc/nginx as the base directory)

$ cdr -bpublic
(Use ./public as the base directory)
```

### -f, --filter=\<command\>

Use the `command` to select a directory.
The default value is the value of `CDR_FILTER (percol)`.
This option takes precedence over `CDR_FILTER`.

```
$ cdr -ffzy
(Use fzy to select the directory)

$ cdr -f'fzf --layout=reverse --preview='"'"'printf "# %s\n" {}; ls {}'"'"''
(Use fzf with preview to select the directory)
```

### -g, --git

Enable searching from Git managed directories.
The default value is the value of `CDR_GIT (false)`.
This option is equivalent to `--base "$(git rev-parse --show-toplevel)" --source 'echo .; git ls-tree -rd --name-only --full-tree HEAD'`.
This option takes precedence over `CDR_GIT`.

```
$ cdr -g
(Select a directory from Git managed directories)
```

### -G, --no-git

Disable searching from Git managed directories.
-g/--git and -G/--no-git can be specified at the same time, but the last one takes precedence.
This option takes precedence over `CDR_GIT`.

```
$ cdr -G
(Select a directory from directories under the current directory)
```

### -s, --source=\<command\>

Use the `command` to list directories.
The default value is the value of `CDR_SOURCE (find -type d)`.
This option takes precedence over `CDR_SOURCE`.

```
$ cdr -sls
(Use ls to list directories)

$ cdr -s'echo /etc/nginx; echo /var/log/nginx'
(Use combined command to list directories)
```

### -w, --wrapper=\<shell\>

Output the wrapper script for `shell` and exit.

Supported shells are as follows:

- sh
- bash
- zsh
- yash
- fish

```
$ eval "$(cdr -w sh)"
(Enable the shell integration for the shell compatible with Bourne Shell)

$ eval "$(cdr -w bash)"
(Enable the shell integration for Bash)

$ eval "$(cdr -w zsh)"
(Enable the shell integration for Zsh)

$ eval "$(cdr -w yash)"
(Enable the shell integration for Yash)

$ source (cdr -w fish | psub)
(Enable the shell integration for Fish)
```

### --help

Print usage and exit.

```
$ cdr --help
(Print usage)
```

### [\<directory\>]

Chdir to the `directory` without selecting.

```
$ cdr /etc/nginx
(Chdir to /etc/nginx)
```

Variables
---------

### `CDR_BASE`

The directory to set the base directory.
The default value is none.

```
$ export CDR_BASE=/etc/nginx
(Use /etc/nginx to the base directory)

$ export CDR_BASE=public
(Use ./public to the base directory)
```

### `CDR_FILTER`

The command to use select a directory.
The default value is `percol`.

```
$ export CDR_FILTER=fzy
(Use fzy to select the directory)

$ export CDR_FILTER='fzf --layout=reverse --preview='"'"'printf "# %s\n" {}; ls {}'"'"''
(Use fzf with preview to select the directory)
```

### `CDR_GIT`

Whether to enable searching from Git managed directories.
The default value is `false`.

```
$ export CDR_GIT=true
(Enable searching from Git managed directories.)

$ export CDR_GIT=false
(Disable searching from Git managed directories.)
```

### `CDR_SOURCE`

The command to list directories.
The default value is `find -type d`.

```
$ export CDR_SOURCE='ls'
(Use ls to list directories)

$ export CDR_SOURCE='echo /etc/nginx; echo /var/log/nginx'
(Use combined command to list directories)
```

License
-------

MIT License

Author
------

nil2 <nil2@nil2.org>
