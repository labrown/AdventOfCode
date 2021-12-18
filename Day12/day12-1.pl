#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Perltidy;
use Graph::Undirected;

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

# Load graph
my $g = Graph::Undirected->new;
for my $edge (@data) {
    my ( $start, $end ) = split( /-/, $edge );
    $g->add_edge( $start, $end );
}

# print "Graph is: $g\n";
# my @edges = $g->edges;
# print Dumper( \@edges );
# my @vertices = $g->vertices;
# print Dumper( \@vertices );

# Start at start node, look for all paths that
# only use a small cave once
my @vertices = $g->vertices;

# Initialize used hash
my %used;
map { $used{$_} = 0 } @vertices;

my @path;
my $path_count = 0;

sub find_path {
    my $vertex = shift;
    #    print "Finding path from $vertex\n";

    # Did I find end?
    if ( $vertex eq "end" ) {
        push @path, $vertex;
        $path_count++;
        print join( ",", @path ), "\n";
        pop @path;
    }
    else {
        push @path, $vertex;

        # Mark small cave in use
        if ( $vertex =~ /[a-z]+/ ) {
            $used{$vertex} = 1;
        }

        # Get neighbors
        for my $neighbour ( $g->neighbours($vertex) ) {
            # Only go into cave if it is not used
            if ( !$used{$neighbour} ) {
                find_path($neighbour);
            }
        }

        # Mark small cave in use
        if ( $vertex =~ /[a-z]+/ ) {
            $used{$vertex} = 0;
        }
        pop @path;
    }
}

find_path("start");

print "Found $path_count paths\n";
