unit module Terminal::Boxer:ver<0.1>:auth<github:thundergnat>;

sub ss-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('─│┌┬┐├┼┤└┴┘'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub rs-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('─│╭┬╮├┼┤╰┴╯'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub hs-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('━┃┏┳┓┣╋┫┗┻┛'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub lh-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('─┃┎┰┒┠╂┨┖┸┚'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub hl-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('━│┍┯┑┝┿┥┕┷┙'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub sd-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('─║╓╥╖╟╫╢╙╨╜'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub dd-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('═║╔╦╗╠╬╣╚╩╝'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub ds-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('═│╒╤╕╞╪╡╘╧╛'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}


sub ascii-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('-|+++++++++'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}

sub block-box (:&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    draw( :draw('▉▉▉▉▉▉▉▉▉▉▉'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )
}


sub draw (:$draw, :&f, :$col, :$cell, :$indent = '', *@content) is export {
    my $columns = $col // +@content;
    my $cell-chars = $cell // @content».chars.max;
    my &center = &f // sub ($s){
        my $cell = $cell-chars - $s.chars;
        my $pad = ' ' x ceiling($cell/2);
        sprintf "%{$cell-chars}s", "$s$pad";
    }

    my @box = $draw.comb;

    my $top = join @box[0] x $cell-chars, @box[2], @box[3] xx $columns-1, @box[4];
    my $mid = join @box[0] x $cell-chars, @box[5], @box[6] xx $columns-1, @box[7];
    my $bot = join @box[0] x $cell-chars, @box[8], @box[9] xx $columns-1, @box[10];

    sub row (*@row) {
        @row.push: '' while @row < $columns;
        @box[1] ~ (join @box[1], @row».&center) ~ @box[1]
    }

    qq:to/END/;
    $indent$top
    {$indent}{ @content.batch($columns).map( {.&row} ).join: "\n$indent$mid\n$indent" }
    $indent$bot
    END
}


=begin pod

=head1 NAME

Terminal::Boxer - Draw boxed tables in a terminal.

[![Build Status](https://travis-ci.org/thundergnat/Terminal-Boxer.svg?branch=master)](https://travis-ci.org/thundergnat/Terminal-Boxer)

=head1 SYNOPSIS

=begin code :lang<perl6>

use Terminal::Boxer;

say ss-box(:3col, :3cell, :indent("  "), 'A'..'E')

#`[
  ┌───┬───┬───┐
  │ A │ B │ C │
  ├───┼───┼───┤
  │ D │ E │   │
  └───┴───┴───┘
]
=end code

=head1 DESCRIPTION

Use Terminal::Boxer to easily generate "boxed" ASCII tables for display in a terminal.

Has multiple pre-made subs using standard line drawing characters as well as a few
non line drawing options. Provide your own drawing characters or rendering routine if
desired.

=head2 Premade Routines

All of the premade routines take several optional parameters to specify layout and behavior:

=item :&f  -   Optional routine to render the text inside each cell. By default this is a centering routine. Pass in a specialized routine if (for instance) you want to use ANSI color codes but don't want to count the ANSI as characters.

=item :$col -  Optional, number of columns to render the table in. Defaults to the number of elements in @content.

=item :$cell - Optional, cell width in characters. If none provided, uses the maximum width element size from the given content list.

=item :$indent - Optional indent for the rendered table. Defaults to ''. Pass in a value to prepend to each row of the table. (Nominally, but not necessarily, whitespace.)

=item @content - List or array. The actual content rendered to each cell.


If :cols (columns) is not specified, draws a single row table. If @content.elems is not evenly divisible by :cols, pads table with blank cells.

--

C<ss-box(:3col, :3cell, :indent("  "), 'A'..'E')>  single horizontal, single vertical

    ┌───┬───┬───┐
    │ A │ B │ C │
    ├───┼───┼───┤
    │ D │ E │   │
    └───┴───┴───┘
--

C<rs-box(:3col, :3cell, :indent("  "), 'A'..'E')> rounded corner, single horizontal, single vertical

    ╭───┬───┬───╮
    │ A │ B │ C │
    ├───┼───┼───┤
    │ D │ E │   │
    ╰───┴───┴───╯

--

C<hs-box(:3col, :3cell, :indent("  "), 'A'..'E')>  heavy single horizontal, heavy single vertical

    ┏━━━┳━━━┳━━━┓
    ┃ A ┃ B ┃ C ┃
    ┣━━━╋━━━╋━━━┫
    ┃ D ┃ E ┃   ┃
    ┗━━━┻━━━┻━━━┛

--

C<hl-box(:3col, :3cell, :indent("  "), 'A'..'E')>  heavy single horizontal, light single vertical

    ┍━━━┯━━━┯━━━┑
    │ A │ B │ C │
    ┝━━━┿━━━┿━━━┥
    │ D │ E │   │
    ┕━━━┷━━━┷━━━┙

--

C<lh-box(:3col, :3cell, :indent("  "), 'A'..'E')>  light single horizontal, heavy single vertical

    ┎───┰───┰───┒
    ┃ A ┃ B ┃ C ┃
    ┠───╂───╂───┨
    ┃ D ┃ E ┃   ┃
    ┖───┸───┸───┚

--

C<sd-box(:3col, :3cell, :indent("  "), 'A'..'E')>  single horizontal, double vertical

    ╓───╥───╥───╖
    ║ A ║ B ║ C ║
    ╟───╫───╫───╢
    ║ D ║ E ║   ║
    ╙───╨───╨───╜

--

C<ds-box(:3col, :3cell, :indent("  "), 'A'..'E')>  double horizontal, single vertical

    ╒═══╤═══╤═══╕
    │ A │ B │ C │
    ╞═══╪═══╪═══╡
    │ D │ E │   │
    ╘═══╧═══╧═══╛

--

C<dd-box(:3col, :3cell, :indent("  "), 'A'..'E')>  double horizontal, double vertical

    ╔═══╦═══╦═══╗
    ║ A ║ B ║ C ║
    ╠═══╬═══╬═══╣
    ║ D ║ E ║   ║
    ╚═══╩═══╩═══╝

--

C<ascii-box(:3col, :3cell, :indent("  "), 'A'..'E')>  basic ASCII drawing characters

    +---+---+---+
    | A | B | C |
    +---+---+---+
    | D | E |   |
    +---+---+---+

--

C<block-box(:3col, :3cell, :indent("  "), 'A'..'E')>  heavy block drawing characers

    ▉▉▉▉▉▉▉▉▉▉▉▉▉
    ▉ A ▉ B ▉ C ▉
    ▉▉▉▉▉▉▉▉▉▉▉▉▉
    ▉ D ▉ E ▉   ▉
    ▉▉▉▉▉▉▉▉▉▉▉▉▉
]

=head3 Roll your own.

C<draw(:$draw, :&f, :$col, :$cell, :$indent, *@content)>  The basic grawing routine

If you need ultimate control, supply your own drawing characters, routine, anything.

The drawing characters must be a 10 character string of the:
horizontal, vertical, upper left, upper center, upper right, middle left,
middle center, middle right, lower left, lower center, lower right, characters.

For example, the ss-box routine is implemented as:

C<draw( :draw('─│┌┬┐├┼┤└┴┘'), :&f, :col($columns), :cell($cell-chars), :indent($indent), @content )>

with the appropriate defaults.

=head1 AUTHOR

Steve Schulze (thundergnat)

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Steve Schulze

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
