#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';

# load data
my $file = shift @ARGV;
unless ( -r $file ) {
    print STDERR "Unable to read file $file, exiting\n";
    exit 1;
}
my @data = read_file($file);
chomp @data;

my %endings = (
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
);

my %points = (
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
);

my @scores;

for my $line (@data) {
    my @stack;
    my $corrupt = 0;
    for my $token ( split( //, $line ) ) {
        if ( $token =~ /[\(\[\{\<]/ ) {
            # Push ending token onto stack
            push @stack, $endings{$token};
        }
        elsif ( $token =~ /[\)\]\}\>]/ ) {
            # Check token against expected ending token
            my $ending = pop @stack;
            if ( $token ne $ending ) {
                $corrupt = 1;
                last;
            }
        }
        else {
            print "How did we get here?\n";
            print "line is $line\n";
            print "stack: ", ddc( \@stack );
            print "token is $token\n";
        }
    }
    if ( !$corrupt && scalar @stack ) {
        my $score  = 0;
        my $ending = "";
        while ( my $token = pop @stack ) {
            $ending .= $token;
            $score *= 5;
            $score += $points{$token};
        }
        print "$ending - $score total points\n";
        push @scores, $score;
    }
}

my @sorted = sort { $a <=> $b } @scores;
my $length = scalar(@scores);
my $middle = int( $length / 2 );
print "middle score is $sorted[$middle]\n";
