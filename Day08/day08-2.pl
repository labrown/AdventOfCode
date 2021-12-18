#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Algorithm::Permute;

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

my %valid = (
    'abcefg'  => 0,
    'cf'      => 1,
    'acdeg'   => 2,
    'acdfg'   => 3,
    'bcdf'    => 4,
    'abdfg'   => 5,
    'abdefg'  => 6,
    'acf'     => 7,
    'abcdefg' => 8,
    'abcdfg'  => 9
);

my $offset = ord('a');

sub untangle {
    my @terms = @_;

    # Set up for all permutations
    my $p = Algorithm::Permute->new( [ 0 .. 6 ] );
    while ( my @mapping = $p->next ) {

        my $mapstr = join( "", @mapping ), "\n";

        my $found = 1;

        for my $term (@terms) {
            my $candidate;

            # Transalte term into mapping
            for my $char ( sort split( //, $term ) ) {
                $candidate
                    .= chr( $mapping[ ord($char) - $offset ] + $offset );
            }

            # Turn candidate it a sorted string
            $candidate = join( '', sort split( //, $candidate ) );

            # If its not a valid mapping, tap out
            if ( !exists $valid{$candidate} ) {
                $found = 0;
                last;
            }
            else {
                # print "$mapstr $term $candidate GOOD\n";
            }
        }

        if ($found) {
            print "$mapstr found it!\n";
            return @mapping;
        }
        else {
            # print "\n";
        }

    }
}

my $sum = 0;

for my $line (@data) {
    my ( $inputs, $outputs ) = split( / \| /, $line );
    my @map = untangle( split( / /, $inputs ) );

    my $num = "";

    for my $output ( split( / /, $outputs ) ) {
        my $m = "";
        for my $c ( split( //, $output ) ) {
            $m .= chr( $map[ ord($c) - $offset ] + $offset );
        }
        $m = join( '', sort split( //, $m ) );
        $num .= $valid{$m};
    }
    $sum += $num;
}

print "Sum is $sum \n";
