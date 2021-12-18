#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
#use Data::Dumper::Concise;
use Data::Dumper::Perltidy;

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

my $steps = shift @ARGV;

my @energy;

# Load data into energy
for my $row (@data) {
    push @energy, [split( //, $row )];
}

my $rows = scalar @energy;
my $cols = scalar @{ $energy[0] };

###########################################################
sub init_flashed {
    my @flashed;
    for my $r ( 0 .. $rows - 1 ) {
        for my $c ( 0 .. $cols - 1 ) {
            $flashed[$r][$c] = 0;
        }
    }
    return @flashed;
}

###########################################################
sub increase_energy {
    for my $r ( 0 .. $rows - 1 ) {
        for my $c ( 0 .. $cols - 1 ) {
            $energy[$r][$c]++;
        }
    }
}

###########################################################
sub increase_adjacent {
    my ( $r, $c ) = @_;

    # iterate over area around the flashed octopus
    for ( my $or = $r - 1; $or <= $r + 1; $or++ ) {
        for ( my $oc = $c - 1; $oc <= $c + 1; $oc++ ) {
            # print "increasing $or,$oc\n";
            # Skip outside row
            next if $or < 0 || $or > $rows - 1;
            # skip outside col
            next if $oc < 0 || $oc > $cols - 1;
            # Add energy
            $energy[$or][$oc]++;
        }
    }
}

sub flash {
    my ( $r, $c, @flashed ) = @_;

    #print "Flash at $r,$c\n";
    # Flash this octopus
    $flashed[$r][$c] = 1;
    increase_adjacent( $r, $c );
    $energy[$r][$c] = 0;

}

sub reset_flashed {
    my @flashed = @_;

    for my $r ( 0 .. $rows - 1 ) {
        for my $c ( 0 .. $cols - 1 ) {
            $energy[$r][$c] = 0 if $flashed[$r][$c];
        }
    }
}

###########################################################
#print "Begin state:\n";
#print Dumper( \@energy );
my $flash_count = 0;

for ( my $step = 1; $step <= $steps; $step++ ) {
    # print "######################################\n";
    # print "Step $step\n";

    # init flashed data
    my @flashed = init_flashed();

    # feed the beasties
    increase_energy();
    # print "Increased energy\n";
    # print Dumper ( \@energy );

    # Do flashes
    my $done = 0;
    my $iter = 0;
    while ( !$done ) {
        $iter++;
        $done = 1;
        for my $r ( 0 .. $rows - 1 ) {
            for my $c ( 0 .. $cols - 1 ) {
                if ( $energy[$r][$c] > 9 && !$flashed[$r][$c] ) {
                    $flash_count++;
                    # Flash this octopus
                    flash( $r, $c, @flashed );
                    # Turn off done flag so we cycle again
                    $done = 0;
                }
            }
        }
        reset_flashed(@flashed);

        # print "Post Flash iteration $iter:";
        # print Dumper ( \@energy );
        # print "\n";

    }

}

print "Energy matrix after $steps steps:\n";
print "There were $flash_count flashes\n\n";
print Dumper ( \@energy );
