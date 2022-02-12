---
title: "Homework 3"
layout: default
---

<div class='admonition caution'>
<div class='title'>Caution</div>
<div class='content'>
<ul>
<li>You are expected to work individually.</li>
<li><strong>Due: Friday February 25th at 11pm EST (Baltimore time).</strong></li>
<li><em>This assignment is worth 60 points.</em></li>
</ul>
</div>
</div>

## Learning objectives

<div class='admonition success'>
<div class='title'>Objectives</div>
<div class='content'>
<ul>
  <li>Arrays</li>
  <li>Command-line arguments</li>
  <li>Makefiles</li>
  <li>Recursion</li>
  <li>File I/O</li>
</ul>
</div>
</div>

## Overview

In this assignment, you will implement an interpreter for a very simple
graphics processing language.  The goal is to write a program which
interprets drawing commands and renders shapes and filled regions on
a drawing surface.

### Getting started

Do a `git pull` in your clone of the public repository to make sure
you have the latest files.

Create a `homework/hw3` directory in your private repo, and use `cd`
to go into it:

```
$ cd ~/my220repo
$ mkdir -p homework/hw3
$ cd homework/hw3
```

Now copy the starter files from the public repo:

```
$ cp -r ~/cs220-s22-public/homework/hw3/* .
```

### Working with image files

TODO: writeup about how to deal with the fact that the image files
are on ugrad, but they need to be on the local machine to view them.

## Concepts

The drawing program will draw pixels on a 2-D grid.  Each pixel has
a color specified by a combination of red, green, and blue color component
values. Each color component value is an integer in the range 0–255,
inclusive.

When the program generates an image, the input file will specify the
size of the pixel grid as some number of columns and some number of
rows.  The position of a pixel is specified as a column (x) and row (y)
coordinate.  The upper left pixel in the grid has coordinates x=0, y=0.
X coordinate values increase moving to the right, and y coordinate values
increase moving down.  So, if the pixel grid has 320 columns and 240 rows,
the lower right pixel has coordinates x=319, y=239.

## Image files

Once it has processed all of the drawing commands, the program will save
the final image to a text file.  The text file is a sequence of values.
Values are separated by one or more whitespace characters
(`' '`, `'\t'`, `'\n'`, `'\r'`, etc.)

The first two values are the width and height of the output image,
specifed as non-negative decimal integers.  For example, if the first
two values in an image file are

```
320 240
```

then the image will have 320 columns and 240 rows.

Following the width and height values will be a series of 3 × `width` × `height`
byte values, specified in hexadecimal (base 16.)  In hexadecimal, each "digit"
represents a value in the range 0–15, with the letters `a`–`f` representing
10 through 15.  For example, the hexadecimal byte value `3a` represents
(3 × 16) + 10 = 58. (Note that `a` means 10.)

Note that whitespace characters have no significance in an image file
other than to separate data values.  An image file may use newline
characters to avoid having very long lines, but your code to read an
image file should not treat newline characters (or any other kind of
whitespace character) specially.

You can read hexadecimal values in C using `fscanf` as follows. Assuming that
`in` is `FILE*` open for reading input, the code

```c
unsigned val;
int rc = fscanf(in, "%x", &val);
```

would attempt to read a single hexadecimal value into the variable `val`.
(Checking the value of `rc` will allow you to determine whether a hexademical
value was read successfully.)

Each pixel is represented as a red component value, a green component value,
and a blue component value, in that order. (This is why the number of byte values
is three times the number of pixels.)  The pixel color values are specified
row by row.  As an example, let's say the overall image size is 320 columns
and 240 rows. The first 320 × 3 color byte values specify the colors (r/g/b)
of the first row of 320 pixels. The next 320 × 3 byte values specify the colors
of the second row of pixels, and so forth.

In your code, you should use an array of `unsigned char` elements to represent
the pixel color component values for the entire image.  This array should store
the r/g/b pixel color values row by row, the same way that the values are stored
in the image file.

## Image functions

You are required to implement the following two functions:

```c
unsigned char *read_image(const char *filename, int *width, int *height);

int write_image(const char *filename, int width, int height,
                const unsigned char *buf);
```

You should add declarations for these functions to `cs220_paint.h` and definitions
for them to `cs220_paint.c`.

The `read_image` function should read image file data (expecting the format
described above) from the file named by the `filename` parameter.  If the image data is
read successfully,

* the width of the image (number of columns of pixels) should be stored in the
  variable that the `width` pointer is pointing to
* the height of the image (number of rows of pixels) should be stored in the
  variabel that the `height` pointer is pointing to
* the function should return a pointer to a dynamically-allocated array of
  color component values (stored as r/g/b triplets arranged row-by-row,
  as described above)

If `read_image` cannot successfully read a complete image, either because the
file exists, or the contents are not in the correct format, it should return
`NULL`.

The `write_image` function should write image file data to the file named
by the `filename` parameter.  The `width` and `height` parameters indicate
the width and height of the image.  The `buf` parameter is an array of color
component values (r/g/b triples, arranged row by row.)

If `write_image` successfully writes the complete image data, it should
return `1`, otherwise it should return `0`.

## `png2txt` and `txt2png`

The provided `png2txt.c` and `txt2png.c` programs convert between
[PNG files](https://en.wikipedia.org/wiki/Portable_Network_Graphics)
and the text-based image file format described above.  They work
by making calls to your `write_image` and `read_image` functions.

You should create a `Makefile` and add targets so that `png2txt` and `txt2png`
executables can be built, with the following dependencies:

* `png2txt` depends on `png2txt.o`, `pnglite.o`, and `cs220_paint.o`
* `txt2png` depends on `txt2png.o`, `pnglite.o`, and `cs220_paint.o`

The commands for these executables should (naturally) link the depended-on
object files into the correctly-named executable file (`png2txt` or `txt2png`.)

You'll need to add targets for the various `.o` files. Make sure you
specify their dependencies as appropriate (including any header files they
depend on.)

Once you have your `read_image` and `write_image` functions implemented,
and your `Makefile` has targets for `png2txt` and `txt2png`, you are
ready to work with image files.  A good way to test your code at this point
is to convert a provided PNG file `png/ingo.png` into an image file, and
then convert it back to PNG.  Try running the following commands:

```
$ make png2txt txt2png
$ ./png2txt png/ingo.png img/ingo.txt
$ ./txt2png img/ingo.txt png/ingo_copy.png
```

Then, download `png/ingo_copy.png` from your ugrad account. It should look like
this:

<a href="img/ingo.png"><img alt="picture of Ingo the cat" class="keep_original_size" src="img/ingo.png"></a>

If the `png2txt` and `txt2png` programs worked correctly, then you should have
good confidence that your `read_image` and `write_image` functions work correctly.
Now, you can move on to the main program.

## The `cs220_paint` program
