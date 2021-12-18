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

my @basins;

# Initialize basin map
for ( my $r = 0; $r < $rows; $r++ ) {
    for ( my $c = 0; $c < $cols; $c++ ) {
        $basins[$r][$c] = -1;
    }
}

# Initialize low points
my $num_lows = scalar(@lows);
for ( my $i = 0; $i < $num_lows; $i++ ) {
    $basins[$lows[$i][0]][$lows[$i][1]] = $i;
}

# Spread basins out
my $done = 0;
while ( !$done ) {
    $done = 1;
    # cycle through each location
    for ( my $r = 0; $r < $rows; $r++ ) {
        for ( my $c = 0; $c < $cols; $c++ ) {
            # Check for adjacency to a basin

            # Skip 9s, can't be in a basin
            next if $heightmap[$r][$c] == 9;

            # Skip processing locations taht already a set
            next if $basins[$r][$c] != -1;

            # Check up
            if ( $r > 0 && $basins[$r - 1][$c] != -1 ) {
                $basins[$r][$c] = $basins[$r - 1][$c];
                $done = 0;
            }

            # Check right
            if ( $c < $cols - 1 && $basins[$r][$c + 1] != -1 ) {
                $basins[$r][$c] = $basins[$r][$c + 1];
                $done = 0;
            }

            # Check down
            if ( $r < $rows - 1 && $basins[$r + 1][$c] != -1 ) {
                $basins[$r][$c] = $basins[$r + 1][$c];
                $done = 0;
            }

            # Check left
            if ( $c > 0 && $basins[$r][$c - 1] != -1 ) {
                $basins[$r][$c] = $basins[$r][$c - 1];
                $done = 0;
            }
        }
    }
}

# Sum up basin sizes
my @sizes;
for ( my $r = 0; $r < $rows; $r++ ) {
    for ( my $c = 0; $c < $cols; $c++ ) {
        next if $basins[$r][$c] == -1;
        $sizes[$basins[$r][$c]]++;
    }
}

my @sorted   = sort { $b <=> $a } @sizes;
my $largest1 = shift @sorted;
my $largest2 = shift @sorted;
my $largest3 = shift @sorted;

print "result is ", $largest1 * $largest2 * $largest3, "\n";
