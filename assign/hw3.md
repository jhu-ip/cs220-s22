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
  <li>C character strings</li>
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
specifed as unsigned decimal integers.  For example, if the first
two values in an image file are

```
320 240
```

then the image will have 320 columns and 240 rows.
