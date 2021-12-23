#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

my @commands = read_file('data.txt');

my $position = 0;
my $depth = 0;
my $aim = 0;

for my $command (@commands)
{
    chomp($command);

    my ($action, $x) = split(/ /, $command);

    if ($action eq 'down') 
    { $aim += $x }
    elsif ($action eq 'up') 
    { $aim -= $x }
    else {
        $position += $x;
        $depth += $aim * $x;
    }
}

printf("position * depth is %d\n", $position * $depth);
