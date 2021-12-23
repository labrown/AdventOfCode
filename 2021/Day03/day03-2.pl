#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

# load ata
my @diags = read_file('data.txt');
chomp @diags;

# Get numbers of ones and zeroes at a particular index in the diag strings
sub get_bits {
    my ($index, @diags) = @_;

    my $num_diags = scalar @diags;
    my $ones = scalar map { substr($_,$index,1) eq "1" ? 1 : () } @diags;
    my $zeroes = $num_diags - $ones;

    return ( $ones, $zeroes );
}

# Find most or least common bit based on comparison
# string passed in as 'comp_func'
sub find_bit {
    my ($index, $comp_func, @diags) = @_;

    my ($ones, $zeroes) = get_bits($index, @diags);

    return eval($comp_func) ? "1" : "0";
}

# find diag string based on bit function
sub find_diag {
    my ($index, $comp_func, @diags) = @_;

    if (scalar (@diags) == 1)
    {
        return $diags[0];
    }
    else
    {
        my $bit = find_bit($index, $comp_func, @diags);
        my @new_diags = map { substr($_,$index,1) eq $bit ? $_ : ()  } @diags;
        return find_diag( ++$index, $comp_func, @new_diags );
    }
}

# get diag strings
my $oxygen_diag = find_diag(0, '$ones >= $zeroes', @diags);
my $c02_diag = find_diag(0, '$ones < $zeroes', @diags);

# Convert to numbers
my $oxy = oct("0b" . $oxygen_diag);
my $c02 = oct("0b" . $c02_diag);

# print life support rating
printf("life support rating is %d\n", $oxy * $c02);

