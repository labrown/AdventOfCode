#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;

my @readings = read_file('data.txt');
chomp(@readings);

# Number of increases
my $increases = 0;

# Last reading, set to artifically high number to start
my $last = 10000;

for my $reading (@readings)
{
    $increases++ if ($last < $reading);
    $last = $reading
}

print "Increases are $increases\n";
