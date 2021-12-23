#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

my @commands = read_file('data.txt');

my $position = 0;
my $depth = 0;

for my $command (@commands)
{
    my ($action, $x) = split(/ /, $command);

    $depth += $x if ($action eq 'down');
    $depth -= $x if ($action eq 'up');
    $position += $x if ($action eq 'forward');
    $depth = 0 if $depth < 0;
}

printf("position * depth is %d\n", $position * $depth);
