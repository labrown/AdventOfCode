#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use List::Util qw(sum);

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

my @fish = ( 0, 0, 0, 0, 0, 0, 0, 0, 0 );
for my $fish ( split( /,/, $data ) ) {
    $fish[$fish]++;
}

print "state: " . join( ", ", @fish ) . "\n";

for ( my $day = 1; $day <= $days; $day++ ) {
    my @new_fish = ( 0, 0, 0, 0, 0, 0, 0, 0, 0 );
    for ( my $fd = 0; $fd < 9; $fd++ ) {
        if ( $fd == 0 ) {
            $new_fish[8] = $fish[$fd];
            $new_fish[6] = $fish[$fd];
        }
        else {
            $new_fish[ $fd - 1 ] += $fish[$fd];
        }
    }
    $fish[$_] = $new_fish[$_] for ( 0 .. 8 );

    printf(
        "After %2d day%s:%s %5d total, state: %s\n",
        $day,
        ( $day == 1 ) ? ""  : "s",
        ( $day == 1 ) ? " " : "",
        sum(@fish), join( ", ", @fish )
    );
}

print "Finished: ", sum(@fish), " fish\n";
