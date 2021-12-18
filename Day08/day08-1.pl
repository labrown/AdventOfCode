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
my @data = read_file($file);
chomp @data;

my @outputs = map {
    my ( $istr, $ostr ) = split( / \| /, $_ );
    my @outputs = split( /\s/, $ostr );
} @data;

my %lookup = (
    6 => 0,
    2 => 1,
    5 => 0,
    4 => 1,
    3 => 1,
    7 => 1
);

my $count = 0;
map { $count += $lookup{ length($_) } } @outputs;

print "Count is $count\n";
