---
title: "Homework 1"
layout: default
---

<div class='admonition caution'>
<div class='title'>Caution</div>
<div class='content'>
<ul>
<li>You are expected to work individually.</li>
<li><strong>Due: Friday February 11th at 11pm EST (Baltimore time).</strong></li>
<li><em>This assignment is worth 60 points.</em></li>
</ul>
</div>
</div>

## Learning objectives

<div class='admonition success'>
<div class='title'>Objectives</div>
<div class='content'>
<ul>
<li>arithmetic operators</li>
<li>control structures</li>
<li>input collection and validation</li>
<li>version control using <code>git</code></li>
</ul>
</div>
</div>

## Overview

In this assignment, you will create a C program which allows the
user to enter an arithmetic expression of arbitrary length, and which
calculates and outputs the value of that expression. The expression may
consist of numeric literals (floating point values), as well as the two
arithmetic operators `*` (for multiplication) and `/` (for division), but no
parentheses. The result output by the program should not be formatted to
a specific number of decimal places, but displayed with the full precision
of a <span style="text-decoration:underline;">float</span> value.

Your program will validate the user's input. If the user inputs an
expression which is not well-formed (for example missing operands or
operators, contains invalid operators, contains parentheses etc.),
your program will report the error message "malformed expression"
and end immediately with a return value of 1. If the user inputs an
expression which attempts division by zero, your program will report
the error message "division by zero" and end immediately with a return
value of 2. Otherwise, the return value should be 0.

Throughout your work on this assignment, be sure to frequently add, commit
(supplying meaningful messages) and push your changes to your personal
git repository.  After you complete your work on the assignment, you'll
be asked to submit a `gitlog.txt` file, just as in [Homework 0](hw0.html).
However, we expect your log for this homework to show more
activity. Recall that your code is always expected to compile without
errors or warnings. Submissions which don't compile properly may earn
zero points, so be sure to submit to Gradescope early and often! And
once you get a good start on the assignment, always have some earlier
compiling version of your work pushed up to Bitbucket.

You must work individually on this assignment. 

## Specific Requirements

In the homework folder of your private repository (which you renamed
`my220repo` in [Exercise 4](../exercise/ex04.html)), you will
create a new subfolder named **hw1**. In that hw1 subfolder, you will
create your program in a new C source file named **arithmetic.c**. At
the top of the file, be sure to add two comment lines that indicate your
name and JHED ID.

Note that your program will continue collecting (parts of) the expression
entered by the user as long as it is well-formed. A proper expression may
contain zero or more of any kind of whitespace (spaces, tabs, newlines)
between operands and operators. As such, the user will press **ctrl-d**
to indicate the end of the input.  In some situations, the user will
need to press **ctrl-d** twice in a row.

Whenever a badly-formed expression is detected, your program should
output exactly the message "malformed expression" followed by a newline
character. Whenever division by zero is attempted, your program should
output exactly the message "division by zero" followed by a newline
character. At most one of "malformed expression" or "division by zero"
will apply to a given input, since the program is immediately terminated
once one or the other is detected.

Here are several sample runs of the program on ugrad, where $ denotes
the command prompt, and user input is shown in **bold**. Note that the
first line shown below is the command you are expected to use as you
compile your program (and the one that will be used by the graders).
The compilation line should report zero errors and warnings, as
demonstrated below (user input is shown in **bold**, `$` indicates the
command prompt):


<div class="highlighter-rouge"><pre>
$ <b>gcc -std=c99 -pedantic -Wall -Wextra arithmetic.c</b>
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>5.25</b>
5.250000
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>3* </b>
<b>4.3/2</b>
6.450000
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>100 / 7 * 20 * -5</b>
-1428.571533
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>100 / 0 * 20 * * * -5 </b>
division by zero
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>20.5 */-50</b>
malformed expression
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<b>3 * 4 - 2</b>
malformed expression
$ <b>./a.out</b>
Please enter an arithmetic expression using * and / only: 
<i>(user enters nothing prior to ctrl-d)</i>
malformed expression
</pre></div>

Note that there may be other ways for the input expressions to be
malformed, besides the three ways shown above. You must be careful to
check for all the various ways it might be malformed. The following
are a additional examples of valid expressions:

```
5. * 1
```

```
.1 * .5
```

```
-.5
```

```
1 * +1
```

```
1 / 01
 * 2
```

## Submission

Create a .zip file named `hw1.zip` which contains only **arithmetic.c**
and **gitlog.txt**. Copy the `hw1.zip` file to your local machine, and
submit it as **Homework 1** on Gradescope. When you submit, gradescope
conducts a series of automatic tests.  These tests do basic things like
check that you submitted the right files and that your `.c` file compiles
properly.  If you see error messages here (look for red), address them and
resubmit. You may re-submit any number of times prior to the deadline;
only your latest submission will be graded. Review the course syllabus
for late submission policies (grace period and late days), and remember
that if your final submitted code does not compile, you will likely earn
a zero score for the assignment.

Two notes regarding automatic checks for programming assignments:


* Passing an automatic check is not itself worth points.  (There might be
  a nominal, low point value like 0.01 associated with a check, but that
  won’t count in the end.) The checks exist to help you and the graders
  find obvious errors.  This will be true for most of the assignments;
  the actual grades are given manually by the graders, along with comments.
* The automatic checks cover some of the requirements set out in the
  assignment, but not all. In general, it is up to you to test your
  own work and ensure your programs satisfy _all stated requirements_.
Passing all the automatic checks does not necessarily mean you will earn
all the points.
