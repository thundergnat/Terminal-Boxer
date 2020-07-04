NAME
====

Terminal::Boxer - Draw boxed tables in a terminal.

[![Build Status](https://travis-ci.org/thundergnat/Terminal-Boxer.svg?branch=master)](https://travis-ci.org/thundergnat/Terminal-Boxer)

SYNOPSIS
========

```perl6
use Terminal::Boxer;

say ss-box(:3col, :3cell, :indent("  "), 'A'..'E')

#`[
  ┌───┬───┬───┐
  │ A │ B │ C │
  ├───┼───┼───┤
  │ D │ E │   │
  └───┴───┴───┘
]
```

DESCRIPTION
===========

Use Terminal::Boxer to easily generate "boxed" ASCII tables for display in a terminal.

Has multiple pre-made subs using standard line drawing characters as well as a few non line drawing options. Provide your own drawing characters or rendering routine if desired.

Premade Routines
----------------

All of the premade routines take several optional parameters to specify layout and behavior:

  * :&f - Optional routine to render the text inside each cell. By default this is a centering routine. Pass in a specialized routine if (for instance) you want to use ANSI color codes but don't want to count the ANSI as characters.

  * :$col - Optional, number of columns to render the table in. Defaults to the number of elements in @content.

  * :$cell - Optional, cell width in characters. If none provided, uses the maximum width element size from the given content list.

  * :$indent - Optional indent for the rendered table. Defaults to ''. Pass in a value to prepend to each row of the table. (Nominally, but not necessarily, whitespace.)

  * @content - List or array. The actual content rendered to each cell.

If :cols (columns) is not specified, draws a single row table. If @content.elems is not evenly divisible by :cols, pads table with blank cells.

--

`ss-box(:3col, :3cell, :indent(" "), 'A'..'E')` single horizontal, single vertical

    ┌───┬───┬───┐
    │ A │ B │ C │
    ├───┼───┼───┤
    │ D │ E │   │
    └───┴───┴───┘

--

`rs-box(:3col, :3cell, :indent(" "), 'A'..'E')` rounded corner, single horizontal, single vertical

    ╭───┬───┬───╮
    │ A │ B │ C │
    ├───┼───┼───┤
    │ D │ E │   │
    ╰───┴───┴───╯

--

`hs-box(:3col, :3cell, :indent(" "), 'A'..'E')` heavy single horizontal, heavy single vertical

    ┏━━━┳━━━┳━━━┓
    ┃ A ┃ B ┃ C ┃
    ┣━━━╋━━━╋━━━┫
    ┃ D ┃ E ┃   ┃
    ┗━━━┻━━━┻━━━┛

--

`hl-box(:3col, :3cell, :indent(" "), 'A'..'E')` heavy single horizontal, light single vertical

    ┍━━━┯━━━┯━━━┑
    │ A │ B │ C │
    ┝━━━┿━━━┿━━━┥
    │ D │ E │   │
    ┕━━━┷━━━┷━━━┙

--

`lh-box(:3col, :3cell, :indent(" "), 'A'..'E')` light single horizontal, heavy single vertical

    ┎───┰───┰───┒
    ┃ A ┃ B ┃ C ┃
    ┠───╂───╂───┨
    ┃ D ┃ E ┃   ┃
    ┖───┸───┸───┚

--

`sd-box(:3col, :3cell, :indent(" "), 'A'..'E')` single horizontal, double vertical

    ╓───╥───╥───╖
    ║ A ║ B ║ C ║
    ╟───╫───╫───╢
    ║ D ║ E ║   ║
    ╙───╨───╨───╜

--

`ds-box(:3col, :3cell, :indent(" "), 'A'..'E')` double horizontal, single vertical

    ╒═══╤═══╤═══╕
    │ A │ B │ C │
    ╞═══╪═══╪═══╡
    │ D │ E │   │
    ╘═══╧═══╧═══╛

--

`dd-box(:3col, :3cell, :indent(" "), 'A'..'E')` double horizontal, double vertical

    ╔═══╦═══╦═══╗
    ║ A ║ B ║ C ║
    ╠═══╬═══╬═══╣
    ║ D ║ E ║   ║
    ╚═══╩═══╩═══╝

--

`ascii-box(:3col, :3cell, :indent(" "), 'A'..'E')` basic ASCII drawing characters

    +---+---+---+
    | A | B | C |
    +---+---+---+
    | D | E |   |
    +---+---+---+

--

`block-box(:3col, :3cell, :indent(" "), 'A'..'E')` heavy block drawing characers

    ▉▉▉▉▉▉▉▉▉▉▉▉▉
    ▉ A ▉ B ▉ C ▉
    ▉▉▉▉▉▉▉▉▉▉▉▉▉
    ▉ D ▉ E ▉   ▉
    ▉▉▉▉▉▉▉▉▉▉▉▉▉

]

### Roll your own.

`draw(:$draw, :&f, :$col, :$cell, :$indent, *@content)` The basic grawing routine

If you need ultimate control, supply your own drawing characters, routine, anything.

The drawing characters must be a 10 character string of the: horizontal, vertical, upper left, upper center, upper right, middle left, middle center, middle right, lower left, lower center, lower right, characters.

For example, the ss-box routine is implemented as:

`draw( :draw('─│┌┬┐├┼┤└┴┘'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )`

with the appropriate defaults.

AUTHOR
======

Steve Schulze (thundergnat)

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Steve Schulze

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

