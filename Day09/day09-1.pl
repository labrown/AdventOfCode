#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

my @heightmap;

# Load data into heightmap
for my $row (@data) {
    push @heightmap, [split( //, $row )];
}

my $rows = scalar @heightmap;
my $cols = scalar @{ $heightmap[0] };

print "$rows x $cols\n";

my $sum = 0;

my @lows;

for my $r ( 0 .. $rows - 1 ) {
    for my $c ( 0 .. $cols - 1 ) {
        my $height = $heightmap[$r][$c];
        my $low    = 1;

        # Check up
        if ( $r > 0 && $heightmap[$r - 1][$c] <= $height ) {
            $low = 0;
        }

        # Check right
        if ( $c < $cols - 1 && $heightmap[$r][$c + 1] <= $height ) {
            $low = 0;
        }

        # Check down
        if ( $r < $rows - 1 && $heightmap[$r + 1][$c] <= $height ) {
            $low = 0;
        }

        # Check left
        if ( $c > 0 && $heightmap[$r][$c - 1] <= $height ) {
            $low = 0;
        }

        if ($low) {
            $sum += $height + 1;
            push @lows, [$r, $c];
        }
    }
}

print "Sum is $sum\n";
