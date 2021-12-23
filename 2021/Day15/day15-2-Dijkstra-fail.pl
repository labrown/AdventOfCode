#!/usr/bin/env perl

#####################################################################
## Using Graph and SP_Dijkstra for the expanded grid requires
## 16GB of memory and more than 1.5 hours of runtime.  I gave up
## before it completed.  Tring a different solution
#####################################################################

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';
use Graph::Directed;

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
# Create vertex label
sub vl {
    my ( $r, $c ) = @_;
    return "${r}_${c}";
}

#####################################################################
# Generate edge data for a location
sub get_edges {
    my ( $r, $c, @grid ) = @_;

    my @edges;

    my $end    = vl( $r, $c );
    my $weight = $grid[$r][$c];

    # Check up
    if ( $r > 0 ) { push @edges, vl( $r - 1, $c ), $end, $weight; }

    # Check right
    if ( $c < $cols - 1 ) { push @edges, vl( $r, $c + 1 ), $end, $weight; }

    # Check down
    if ( $r < $rows - 1 ) { push @edges, vl( $r + 1, $c ), $end, $weight; }

    # Check left
    if ( $c > 0 ) { push @edges, vl( $r, $c - 1 ), $end, $weight; }

    return @edges;

}

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

# print "big grid is\n";
# print_grid(@big_grid);
# exit;

#####################################################################
# Create graph object and load data into it
my $big_rows = scalar(@big_grid);
my $big_cols = scalar( @{ $big_grid[0] } );

my @edges;
for ( my $r = 0; $r < $big_rows; $r++ ) {
    for ( my $c = 0; $c < $big_cols; $c++ ) {
        push @edges, get_edges( $r, $c, @big_grid );
    }
}

my $graph = Graph::Directed->new;
$graph->add_weighted_edges(@edges);

#####################################################################
# Run search
my @path
    = $graph->SP_Bellman_Ford( vl( 0, 0 ),
        vl( $big_rows - 1, $big_cols - 1 ) );

shift @path;    # skip first one

print "Path is ", ddc( \@path );

my $risk = 0;
while ( my $vertex = shift @path ) {
    my ( $r, $c ) = split( /_/, $vertex );
    my $vertex_risk = $big_grid[$r][$c];
    $risk += $vertex_risk;
    print "Adding $r,$c, with risk $vertex_risk for total risk $risk\n";
}
print "Total risk is $risk\n";
