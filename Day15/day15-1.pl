#!/usr/bin/env perl

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
print "$rows x $cols\n";

print ddc( \@grid );

sub vl {
    my ( $r, $c ) = @_;
    return "${r}_${c}";
}

sub get_edges {
    my ( $r, $c ) = @_;

    my @edges;

    my $end    = vl( $r, $c );
    my $weight = $grid[$r][$c];

    # Check up
    if ( $r > 0 ) {
        push @edges, vl( $r - 1, $c ), $end, $weight;
    }

    # Check right
    if ( $c < $cols - 1 ) {
        push @edges, vl( $r, $c + 1 ), $end, $weight;
    }

    # Check down
    if ( $r < $rows - 1 ) {
        push @edges, vl( $r + 1, $c ), $end, $weight;
    }

    # Check left
    if ( $c > 0 ) {
        push @edges, vl( $r, $c - 1 ), $end, $weight;
    }

    print "$end - $weight ", ddc( \@edges );
    return @edges;

}

#####################################################################
# Create graph object and load data into it

my @edges;
print "Grid is\n";
for ( my $r = 0; $r < $rows; $r++ ) {
    for ( my $c = 0; $c < $cols; $c++ ) {
        #print $grid[$r][$c];
        push @edges, get_edges( $r, $c );
    }
    #print "\n";
}

# print "Edges: \n", ddc( \@edges );

my $graph = Graph::Directed->new;
$graph->add_weighted_edges(@edges);

print "The Graph:\n";
print "$graph\n";

# print ddc($graph);

my @path = $graph->SP_Dijkstra( vl( 0, 0 ), vl( $rows - 1, $cols - 1 ) );

shift @path;    # skip first one

print "Path is ", ddc( \@path );

my $risk = 0;
while ( my $vertex = shift @path ) {
    my ( $r, $c ) = split( /_/, $vertex );
    my $vertex_risk = $grid[$r][$c];
    $risk += $vertex_risk;
    print "Adding $r,$c, with risk $vertex_risk for total risk $risk\n";
}
print "Total risk is $risk\n";
