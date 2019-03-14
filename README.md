# hop

Simple Bash utility for navigating quickly to set directories.

## Usage

```shell
$ hop myproject
```

The script will search at `~/.hopdirs` for directory paths ending with `myproject` as a directory name.
If found, it will `cd` there.

Lookups are case-insensitive and autocomplete functionality is provided.

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

The hopdirs file path can be changed from `~/.hopdirs` by setting the variable `HOPDIRS_FILE`:

```shell
$ export HOPDIRS_FILE=/path/to/hopdirs
$ hop myproject
```
