#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';
use Hash::PriorityQueue;

#####################################################################
# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

#####################################################################
# Load data into grid array
my @grid;
for my $row (@data) {
    push @grid, [split( //, $row )];
}
my $rows = scalar @grid;
my $cols = scalar @{ $grid[0] };

#####################################################################
# Expand base grid into big grid
sub expand_grid {
    my ( $br, $bc, $rows, $cold, $grid, $big_grid ) = @_;

    for ( my $r = 0; $r < $rows; $r++ ) {
        for ( my $c = 0; $c < $cols; $c++ ) {
            # Calculate expaded big grid value
            my $risk = $$grid[$r][$c] + $br + $bc;
            $risk = $risk - 9 if $risk > 9;
            # Copy grid value into big_grid location
            $$big_grid[( $br * $rows ) + $r][( $bc * $cols ) + $c] = $risk;
        }
    }
}

#####################################################################
# Build expanded grid
sub print_grid {
    my @grid = @_;

    my $rows = scalar(@grid);
    my $cols = scalar( @{ $grid[0] } );

    for ( my $r = 0; $r < $rows; $r++ ) {
        for ( my $c = 0; $c < $cols; $c++ ) {
            print $grid[$r][$c];
        }
        print "\n";
    }
}

#####################################################################
# Build expanded grid
my @big_grid;
for ( my $br = 0; $br < 5; $br++ ) {
    for ( my $bc = 0; $bc < 5; $bc++ ) {
        expand_grid( $br, $bc, $rows, $cols, \@grid, \@big_grid );
    }
}

#####################################################################
# Create graph object and load data into it
my $big_rows = scalar(@big_grid);
my $big_cols = scalar( @{ $big_grid[0] } );

#####################################################################
# Search for lowest cost path
#
# Inspiration for this taken from other AoCers.

my $pq = Hash::PriorityQueue->new();

# Insert Starting position
$pq->insert( [0, 0, 0], 0 );

# Initialize visited object
my @visited;

while ( my $next = $pq->pop() ) {
    my ( $r, $c, $rf ) = @$next;

    # Have we been here before?
    next if ( $visited[$r][$c] );

    # Have we found our destination?
    if ( $r == $big_rows - 1 && $c == $big_cols - 1 ) {
        print "Total Risk is $rf\n";
        last;
    }

    # Mark visited
    $visited[$r][$c] = 1;

    # Check grids next to us
    for my $delta ( [$r - 1, $c], [$r + 1, $c], [$r, $c - 1], [$r, $c + 1] ) {
        my ( $nr, $nc ) = @$delta;

        # Must be in grid and not visited yet
        if ( $nr >= 0
            && $nr < $big_rows
            && $nc >= 0
            && $nc < $big_cols
            && !$visited[$nr][$nc] )
        {
            my $nrf = $rf + $big_grid[$nr][$nc];
            $pq->insert( [$nr, $nc, $nrf], $nrf );
        }
    }
}
