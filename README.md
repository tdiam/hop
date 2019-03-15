# hop

Simple Bash utility for navigating quickly to set directories.

## Usage

```shell
$ hop --help
Usage: hop [-i] DIRNAME
    Hops to directories defined in /home/username/.hopdirs by only using their name.

    Options:
      -i        Ignore case when searching through directory names.

$ hop Teal-Album
```

The script will search at `~/.hopdirs` for directories named `Teal-Album`. If found, it will `cd` there.

## Adding directories

`.hopdirs` is a list of directory paths separated by new lines.

### Example 1

As a manually maintained list of bookmarks:
```
# .hopdirs
/home/username/Projects/myproject
/home/username/Music/Weezer/Teal-Album
```

> **NOTE:** Lines that start with `#` are ignored.

### Example 2

Or generated with `find` to simplify navigation in a nested hell of directories:
* university/
  * courses/
    * 2018-19/
      * algorithms/
      * databases/
      * comparch/
    * 2017-18/
      * dsp/
      * discrete-math/
      * calculus-ii/
    * ...

```shell
$ find /path/to/university -mindepth 3 maxdepth 3 -type d -print >> ~/.hopdirs

# Hop hop hop
$ hop calculus-ii
```

## Installation

Just source `hop.sh`:
```shell
$ . hop.sh
```

You can also add it to your `.bashrc` and then have it available every time you launch your shell.
```shell
# .bashrc
# ...rest of the file

if [ -f /path/to/hop.sh ]; then
	. /path/to/hop.sh
fi
```

## Configuration

`hop` can be customized through the following environment variables.

* `HOPDIRS_FILE`:  
  Path to the hopdirs file. Default is `~/.hopdirs`.
* `HOP_ICASE`:  
  Set to `1` to force case-insensitive lookups and autocompletions. Default is `0`.

### Example

```shell
$ export HOPDIRS_FILE=/path/to/hopdirs
$ export HOP_ICASE=1
$ hop teal-album
```
