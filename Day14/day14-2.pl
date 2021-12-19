#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';
use List::Util qw( sum );
use POSIX;

STDOUT->autoflush(1);

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
sub get_template {
    my $data = shift;

    my $template = shift @$data;
    shift @$data;

    return $template;
}

#####################################################################
sub get_rules {
    my $data = shift;

    my %rules;

    while ( my $line = shift @$data ) {
        my ( $pair, $element ) = split( / -> /, $line );
        $rules{$pair} = $element;
    }

    return \%rules;
}

#####################################################################
sub get_pairs2 {
    my $template = shift;

    my %pairs;
    my $tl = length($template);
    for ( my $i = 0; $i < $tl - 1; $i++ ) {
        $pairs{ substr( $template, $i, 2 ) }++;
    }
    return \%pairs;
}

#####################################################################
sub insert_pairs {
    my $template = shift;
    my $rules    = shift;
    my @pairs    = @_;

    my $ii = length($template) - 1;
    while ( my $pair = pop @pairs ) {
        substr( $template, $ii--, 0 ) = $$rules{$pair};
    }

    return $template;
}

#####################################################################
sub split_pair {
    my $pair  = shift;
    my $rules = shift;

    # split pair into elements
    my ( $first, $last ) = split( //, $pair );
    # Get insert element
    my $element = $$rules{$pair};

    # Return two new pairs
    return $first . $element, $element . $last;
}

sub sum_elements {
    my $pairs = shift;

    my $elements = {};

    # sum up elements
    foreach my $pair ( keys %$pairs ) {
        my $count         = $$pairs{$pair};
        my @pair_elements = split( //, $pair );
        foreach my $pe (@pair_elements) {
            $$elements{$pe} += $count;
        }
    }

    foreach my $element ( keys %$elements ) {
        $$elements{$element} = ceil( $$elements{$element} / 2 );
    }

    return $elements;
}
#####################################################################
## MAIN
#####################################################################

my $template = get_template( \@data );
my $rules    = get_rules( \@data );

my $pairs = get_pairs2($template);

#print ddc($pairs);

for ( my $step = 1; $step <= 40; $step++ ) {
    my $new_pairs = {};

    foreach my $pair ( keys %$pairs ) {
        my $num_pairs = $pairs->{$pair};
        my @new_split = split_pair( $pair, $rules );
        foreach my $new_pair (@new_split) {
            $$new_pairs{$new_pair} += $num_pairs;
        }
    }
    $pairs = $new_pairs;
    #     print "Step $step\n";
    #     print ddc($pairs);
    #     print "Total Pairs: ", sum( values(%$pairs) ), "\n";
    #     print "elements: ", ddc( sum_elements($pairs) );
}

my $elements = sum_elements($pairs);

my @sorted_sizes = sort { $a <=> $b } values(%$elements);

print "result is ", $sorted_sizes[$#sorted_sizes] - $sorted_sizes[0], "\n";

