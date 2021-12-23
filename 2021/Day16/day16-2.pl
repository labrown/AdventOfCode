#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use File::Slurp;
use Data::Dumper::Compact 'ddc';
use Graph::Directed;
use List::Util qw( sum product min max );

#####################################################################
# load data
sub load_data {
    my $file = shift;
    unless ( -r $file ) {
        print STDERR "Unable to read file $file, exiting\n";
        exit 1;
    }
    my @data = read_file($file);
    chomp @data;
    return @data;
}

#####################################################################
# Convert input to bit string
sub data_to_bits {
    my @data = shift;

    my $bits = "";
    foreach my $input (@data) {
        foreach my $hex_digit ( split( //, $input ) ) {
            $bits .= sprintf( "%04b", hex($hex_digit) );
        }
    }
    return $bits;
}
#####################################################################
## Load data and convert to bit string
## Placed here to allow $bits to be a global value
#####################################################################
my @data = load_data( shift @ARGV );
my $bits = data_to_bits(@data);

#####################################################################
# Get a specific number of bits from string and return as a number
sub parse_number {
    my $num_bits = shift;

    my $number = oct( "0b" . substr( $bits, 0, $num_bits ) );
    $bits = substr( $bits, $num_bits );
    return $number;
}

#####################################################################
# Get a specific number of bits from string and return as a number
sub parse_bits {
    my $num_bits = shift;

    my $bit_str = substr( $bits, 0, $num_bits );
    $bits = substr( $bits, $num_bits );
    return $bit_str;
}

#####################################################################
# Get a literal value out of the bit stream
sub parse_literal {

    my $literal_bits = "0b";
    while (1) {
        my $next      = parse_number(1);
        my $next_bits = parse_bits(4);

        $literal_bits .= $next_bits;
        last if ( $next == 0 );
    }
    return oct($literal_bits);
}

sub parse_packet {
    # Get packet version
    my $version = parse_number(3);

    # get packet typeid
    my $typeid = parse_number(3);

    say "Packet version $version, type $typeid";

    my $value;

    if ( $typeid == 4 ) {
        # This is a literal value packet
        $value = parse_literal();
        say "Literal value $value";
    }
    else {
        # This is an operator packet
        my $length = parse_number(1);

        my @packet_values;

        if ( $length == 0 ) {
            my $num_packet_bits     = parse_number(15);
            my $current_bits_length = length($bits);
            while ( length($bits) != $current_bits_length - $num_packet_bits )
            {
                push @packet_values, parse_packet();
            }
        }
        elsif ( $length == 1 ) {
            my $num_packets = parse_number(11);
            foreach my $pi ( 1 .. $num_packets ) {
                push @packet_values, parse_packet();
            }
        }

        print ddc( \@packet_values );

        if ( $typeid == 0 ) {
            say "sum";
            $value = sum @packet_values;
        }
        elsif ( $typeid == 1 ) {
            say "product";
            $value = product @packet_values;
        }
        elsif ( $typeid == 2 ) {
            say "min";
            $value = min @packet_values;
        }
        elsif ( $typeid == 3 ) {
            say "max";
            $value = max @packet_values;
        }
        elsif ( $typeid == 5 ) {
            say "greater";
            $value = $packet_values[0] > $packet_values[1] ? 1 : 0;
        }
        elsif ( $typeid == 6 ) {
            say "less";
            $value = $packet_values[0] < $packet_values[1] ? 1 : 0;
        }
        elsif ( $typeid == 7 ) {
            say "equal";
            $value = $packet_values[0] == $packet_values[1] ? 1 : 0;
        }
    }

    return $value;
}

#####################################################################
# MAIN

say $bits;
my $value = parse_packet();
say $bits;
say "Value is $value";
