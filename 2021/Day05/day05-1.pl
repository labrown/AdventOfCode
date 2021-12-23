#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use String::Scanf;
use Data::Dumper::Compact 'ddc';

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

# Process data
my @grid;
for my $line (@data) {
    # Parse line
    my ( $x1, $y1, $x2, $y2 ) = sscanf( "%d,%d -> %d,%d", $line );

    # Is it horizontal?
    if ( $x1 == $x2 ) {
        # process horizontal line
        print "Horizontal: $x1,$y1 -> $x2, $y2\n";
        my ( $start, $end ) = sort { $a <=> $b } $y1, $y2;
        print "Running line $start .. $end\n";
        for my $ys ( $start .. $end ) {
            $grid[$ys][$x1]++;
        }
    }
    # Is it vertical?
    if ( $y1 == $y2 ) {
        # Process vertical line
        print "Vertical: $x1,$y1 -> $x2, $y2\n";
        my ( $start, $end ) = sort { $a <=> $b } $x1, $x2;
        print "Running line $start .. $end\n";
        for my $xs ( $start .. $end ) {
            $grid[$y1][$xs]++;
        }
    }
}

my $twos = 0;
for my $gridline (@grid) {
    for my $point (@$gridline) {
        next    if !defined($point);
        $twos++ if $point >= 2;
    }
}

print "Found $twos grids two or worse\n";

# print ddc( \@grid );

# sub gridprint {
#     for my $gridline (@grid) {
#         for my $point (@$gridline) {
#             printf "%s", defined($point) ? $point : '.';
#         }
#         print "\n";
#     }
# }

# gridprint();

# # get max width of grid lines
# my $largest_last = 0;
# for my $gridline (@grid) {
#     my $last = $#$gridline;
#     print "last is $last\n";
#     $largest_last = $last if $last > $largest_last;
# }

# # Adjust grid
# for my $gridline (@grid) {
#     my $last = $#$gridline;
#     $$gridline[$largest_last] = undef if $largest_last > $last;
# }

# print "\n";

# gridprint();
