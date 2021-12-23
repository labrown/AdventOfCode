#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';
use Graph::Undirected;

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
# Put dots into all other locations in paper
# For readability
sub fillin {
    my $paper = shift;

    my $g = $$paper{g};

    for ( my $x = 0; $x <= $$paper{mx}; $x++ ) {
        for ( my $y = 0; $y <= $$paper{my}; $y++ ) {
            $$g[$x][$y] = '.' unless exists $$g[$x][$y];
        }
    }
}

#####################################################################
sub load_paper {
    my $data = shift;

    my %paper = (
        mx => 0,
        my => 0,
        g  => []
    );

    # Initialize paper
    while ( my $line = shift @$data ) {
        #print "line is >$line<\n";
        # Am I dont with locations?
        last if ( $line =~ /^$/ );

        my ( $x, $y ) = split( /,/, $line );

        $paper{'g'}->[$x][$y] = '#';

        $paper{'mx'} = $x if $paper{'mx'} < $x;
        $paper{'my'} = $y if $paper{'my'} < $y;
    }

    # Increment by one to make it right

    fillin( \%paper );

    return \%paper;
}

#####################################################################
sub print_paper {
    my $paper = shift;

    # printf( "in print_paper size: %d,%d\n", $$paper{mx} + 1,
    #     $$paper{my} + 1 );
    # print ddc ($paper);

    my $g = $$paper{g};

    for ( my $y = 0; $y <= $$paper{my}; $y++ ) {
        for ( my $x = 0; $x <= $$paper{mx}; $x++ ) {
            print ${g}->[$x][$y];
        }
        print "\n";
    }
}

#####################################################################
sub copy {
    my ( $max_x, $max_y, $paper ) = @_;

    my %new_paper;

    $new_paper{mx} = $max_x;
    $new_paper{my} = $max_y;
    $new_paper{g}  = [];

    my $og = $$paper{g};

    for ( my $x = 0; $x <= $max_x; $x++ ) {
        for ( my $y = 0; $y <= $max_y; $y++ ) {
            $new_paper{g}->[$x][$y] = $og->[$x][$y];
        }
    }
    return \%new_paper;
}

#####################################################################
sub fold_left {
    my ( $loc, $paper ) = @_;

    # Copy top half to new paper
    my $new_paper = copy( $loc - 1, $$paper{my}, $paper );

    my $og = $$paper{g};

    # Process bottom half onto top half
    for ( my $x = 1; $x <= $loc; $x++ ) {
        for ( my $y = 0; $y <= $$new_paper{my}; $y++ ) {
            next if $$new_paper{g}->[$loc - $x][$y] eq '#';
            #print "$loc + $x\n";
            if ( $og->[$loc + $x][$y] eq '#' ) {
                $$new_paper{g}->[$loc - $x][$y] = '#';
            }
        }
    }
    return $new_paper;

}

#####################################################################
sub fold_up {
    my ( $loc, $paper ) = @_;

    # Copy top half to new paper
    my $new_paper = copy( $$paper{mx}, $loc - 1, $paper );

    my $og = $$paper{g};

    # Process bottom half onto top half
    for ( my $x = 0; $x <= $$new_paper{mx}; $x++ ) {
        for ( my $y = 1; $y <= $loc; $y++ ) {
            next if $$new_paper{g}->[$x][$loc - $y] eq '#';
            if ( $og->[$x][$loc + $y] eq '#' ) {
                $$new_paper{g}->[$x][$loc - $y] = '#';
            }
        }
    }
    return $new_paper;
}

#####################################################################
sub count_dots {
    my $paper = shift;

    my $g = $$paper{g};

    my $count = 0;
    for ( my $y = 0; $y <= $$paper{my}; $y++ ) {
        for ( my $x = 0; $x <= $$paper{mx}; $x++ ) {
            if ( ${g}->[$x][$y] eq "#" ) {
                $count++;
            }
        }
    }

    return $count;
}

#####################################################################
## MAIN
#####################################################################

my $paper = load_paper( \@data );

print "Initial load\n";
printf( "size: %d,%d\n", $$paper{mx} + 1, $$paper{my} + 1 );

# Fold paper
while ( my $line = shift @data ) {

    if ( $line =~ m/^fold along ([xy])=(\d+)$/ ) {
        my $dir = $1;
        my $loc = $2;

        print "folding along $dir at $loc\n";

        if ( $dir eq 'x' ) {
            $paper = fold_left( $loc, $paper );
        }
        elsif ( $dir eq 'y' ) {
            $paper = fold_up( $loc, $paper );
        }
        printf( "%d dots visible\n", count_dots($paper) );
    }
}

print_paper($paper);

