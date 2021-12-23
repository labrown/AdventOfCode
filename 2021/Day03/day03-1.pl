#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

# load data
my @strings = read_file('data.txt');
chomp @strings;

# Transpose diag strings into one string per bit of the diags
my @transposed;
for my $string (@strings)
{
    my $i=0;
    for my $bit (split(//,$string))
    {
        $transposed[$i++] .= "$bit";
    }
}

# find most common bit in each position and
# assign gamma and epsilon bit values appropriately
my $trans_length = scalar $transposed[0];
my $gamma_str = "";
my $epsilon_str = "";

for my $trans (@transposed)
{
    my @counts;
    map { @counts[$_]++ } split(//,$trans);
    if ( $counts[1] > $counts[0])
    {
        $gamma_str .= "1";
        $epsilon_str .= "0";
    }
    else
    {
        $gamma_str .= "0";
        $epsilon_str .= "1";
    }
}

# Convert to numbers
my $gamma = oct("0b" . $gamma_str);
my $epsilon = oct("0b" . $epsilon_str);

# print power consumption
printf("power consumption is %d\n", $gamma * $epsilon);
