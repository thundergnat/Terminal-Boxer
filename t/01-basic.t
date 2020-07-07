use v6.c;
use Test;
use Terminal::Boxer;

plan 13;

my @test =
'┌───┬───┬───┐
│ A │ B │ C │
├───┼───┼───┤
│ D │ E │   │
└───┴───┴───┘

╭───┬───┬───╮
│ A │ B │ C │
├───┼───┼───┤
│ D │ E │   │
╰───┴───┴───╯

┏━━━┳━━━┳━━━┓
┃ A ┃ B ┃ C ┃
┣━━━╋━━━╋━━━┫
┃ D ┃ E ┃   ┃
┗━━━┻━━━┻━━━┛

┍━━━┯━━━┯━━━┑
│ A │ B │ C │
┝━━━┿━━━┿━━━┥
│ D │ E │   │
┕━━━┷━━━┷━━━┙

┎───┰───┰───┒
┃ A ┃ B ┃ C ┃
┠───╂───╂───┨
┃ D ┃ E ┃   ┃
┖───┸───┸───┚

╓───╥───╥───╖
║ A ║ B ║ C ║
╟───╫───╫───╢
║ D ║ E ║   ║
╙───╨───╨───╜

╒═══╤═══╤═══╕
│ A │ B │ C │
╞═══╪═══╪═══╡
│ D │ E │   │
╘═══╧═══╧═══╛

╔═══╦═══╦═══╗
║ A ║ B ║ C ║
╠═══╬═══╬═══╣
║ D ║ E ║   ║
╚═══╩═══╩═══╝

+---+---+---+
| A | B | C |
+---+---+---+
| D | E |   |
+---+---+---+

▉▉▉▉▉▉▉▉▉▉▉▉▉
▉ A ▉ B ▉ C ▉
▉▉▉▉▉▉▉▉▉▉▉▉▉
▉ D ▉ E ▉   ▉
▉▉▉▉▉▉▉▉▉▉▉▉▉

┏━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┳━━┓
┃ 0┃ 1┃ 2┃ 3┃ 4┃ 5┃ 6┃ 7┃ 8┃ 9┃10┃11┃12┃13┃14┃15┃16┃17┃18┃19┃
┗━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┻━━┛

  ╔════════╦════════╦════════╗
  ║ one of ║ things ║  like  ║
  ║  these ║ is not ║   the  ║
  ║        ║        ║ others ║
  ╚════════╩════════╩════════╝

    ╭─────────┬─────────┬─────────╮
    │   one   │  three  │  nine   │
    ├─────────┼─────────┼─────────┤
    │ eleven  │seventeen│         │
    ╰─────────┴─────────┴─────────╯
'.split("\n\n");

my $i = 0;
for &ss-box, &rs-box, &hs-box, &hl-box, &lh-box,
    &sd-box, &ds-box, &dd-box, &ascii-box, &block-box
  -> &f {
    is( f(:3col, :3cw, 'A'..'E').trim, @test[$i], "{&f.name} ok");
    ++$i
}

is( hs-box(^20).trim, @test[$i], "ok with no parameters");
++$i;

is( dd-box( :8cw, :indent("  "), ("one of\nthese", "things\nis not", "like\nthe\nothers")).chomp,
  @test[$i], "multi line content ok");
++$i;

my $mycell = 9;

sub mycenter ($s) {
    my $cell = $mycell - $s.chars;
    my $pad = ' ' x ceiling($cell/2);
    sprintf("%{$mycell}s", "$s$pad")
}

is( rs-box(:f(&mycenter), :3col, :indent("    "), <one three nine eleven seventeen>), @test[$i], "ok with multiple parameters");

done-testing;
