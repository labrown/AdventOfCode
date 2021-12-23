#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use List::Util qw( max  min );
use List::MoreUtils qw(first_index);
use Data::Dumper::Compact 'ddc';

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my $data = read_file($file);
chomp $data;

my @crabs = split( /,/, $data );

my $max = max @crabs;

my @costs = (0) x $max;

sub sumn {
    my $n = shift;
    return ( $n * ( $n + 1 ) ) / 2;
}

for ( my $i = 0; $i < $max; $i++ ) {
    map { $costs[$i] += sumn( abs( $_ - $i ) ); } @crabs;
}

my $mincost = min @costs;

print $costs[ first_index { $_ eq $mincost } @costs ], "\n";

