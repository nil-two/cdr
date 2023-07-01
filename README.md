cdr
===

![CI](https://github.com/nil-two/cdr/workflows/CI/badge.svg)

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
$ cdr [<option(s)>] [<directory>]
chdir with recursive directory searching.

options:
  -b, --base=<directory>  use the directory to the base directory
  -f, --filter=<command>  use the command to select a directory
  -g, --git               enable searching from Git managed directoies
  -G, --no-git            disable searching from Git managed directoies
  -s, --source=<command>  use the command to list directories
  -w, --wrapper=<shell>   output the wrapper script for the shell and exit
      --help              print usage and exit
  [<directory>]           chdir to the directory without selecting

supported-shells:
  sh, bash

environment-variables:
  CDR_BASE    set default -b/--base (default: .)
  CDR_FILTER  set default -f/--filter (default: percol)
  CDR_GIT     set default -g/--git (default: false)
  CDR_SOURCE  set default -s/--source (default: find -type d)
```

Requirements
------------

- sh
- find
- Percol (If you use default CDR\_FILTER)
- Git (If you use -g, --git option)

Installation
------------

1. Copy `cdr` into your `$PATH`.
2. Make `cdr` executable.
3. Add following config to your shell's rc file.

| Shell |                       |
|-------|-----------------------|
| sh    | eval "$(cdr -w sh)"   |
| bash  | eval "$(cdr -w bash)" |

### Example

```
$ curl -L https://raw.githubusercontent.com/nil-two/cdr/master/cdr > ~/bin/cdr
$ chmod +x ~/bin/cdr
$ echo 'eval "$(cdr -w bash)"' >> ~/.bashrc
```

Note: In this example, `$HOME/bin` must be included in `$PATH`.

Options
-------

### -f, --filter=COMMAND

Use COMMAND to select directory.
Default value is value of CDR\_FILTER.
This option takes precedence over CDR\_FILTER.

```
# Use peco to select the directry
cdr -fpeco

# Use fzf with preview to select the directry
cdr -f'fzf --layout=reverse --preview='"'"'printf "# %s\n" {}; ls {}'"'"''
```

### -g, --git

Enable searching from Git managed directoies.
The Git root directory will be searched from the current directory.
If the Git root directory is not found, this option will be ignoreed.
This option takes precedence over CDR\_GIT.

```
# Select a directory from Git managed directoies
cdr -g
```

### -G, --no-git

Disable searching from Git managed directoies.
-g/--git and -G/--no-git can be specified at the same time, but the last one takes precedence.

```
# Select a directory from directories under the current directory
cdr -G
```

### -w, --wrapper=SHELL

Output the wrapper script for SHELL and exit.

Supported shells are as follows:

- sh

```
$ eval "$(cdr -w sh)"
(Enable the shell integration for the shell compatible with Bourne Shell)
```

### --help

Print usage and exit.

```
$ cdr -h
(Print usage)
```

Variables
---------

### `CDR_FILTER`

The command to use select a directory.
Default value is `percol`.

```
# Use peco to select the directry
export CDR_FILTER=peco

# Use fzf with preview to select the directry
export CDR_FILTER='fzf --layout=reverse --preview='"'"'printf "# %s\n" {}; ls {}'"'"''
```

### `CDR_GIT`

Whether to enable searching from Git managed directoies.
Default value is `false`.

```
# Enable searching from Git managed directoies.
export CDR_GIT=true

# Disable searching from Git managed directoies.
export CDR_GIT=false
```

License
-------

MIT License

Author
------

nil2 <nil2@nil2.org>
