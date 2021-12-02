#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

my @readings = read_file('data.txt');
chomp @readings;

# Number of increases
my $increases = 0;

# Number of readings
my $readings = scalar @readings;

# initialize last_sum and current_sum
my $last_sum = 0;
my $current_sum = 0;

for (my $i=0; $i<$readings; $i++)
{
    if ($i < 3)
    {
        # Add current reading to last_sum and set $current_sum
        $last_sum += $readings[$i];
        $current_sum = $last_sum
    }
    else
    {
        # Calculate new current_sum
        $current_sum = $last_sum + $readings[$i] - $readings[$i-3];
        # check for an increase
        $increases++ if $current_sum > $last_sum;
        # save current_sum as last_sum for next step
        $last_sum = $current_sum;
    }
}

print "Increases are $increases\n";
