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
my $data = read_file($file);
chomp $data;

my $days = shift @ARGV;
unless ( $days =~ /\d+/ ) {
    print STDERR "Days must be an integer: $days, exiting\n";
    exit 1;
}

my @fish = split( /,/, $data );

print "initial state: " . join( ",", @fish ) . "\n";

for ( my $day = 1; $day <= $days; $day++ ) {
    my @new_fish;
    for ( my $fi = 0; $fi < scalar(@fish); $fi++ ) {
        $fish[$fi]--;
        if ( $fish[$fi] == -1 ) {
            $fish[$fi] = 6;
            push @new_fish, 8;
        }
    }
    push @fish, @new_fish;

    printf(
        "After %2d day%s:%s %5d\n",
        $day,
        ( $day == 1 ) ? ""  : "s",
        ( $day == 1 ) ? " " : "",
        scalar(@fish)
    );

}
