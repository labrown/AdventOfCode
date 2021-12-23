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
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
);

my $sum = 0;
for my $line (@data) {
    my @stack;
    for my $token ( split( //, $line ) ) {
        if ( $token =~ /[\(\[\{\<]/ ) {
            # Push ending token onto stack
            push @stack, $endings{$token};
        }
        elsif ( $token =~ /[\)\]\}\>]/ ) {
            # Check token against expected ending token
            my $ending = pop @stack;
            if ( $token ne $ending ) {
                print "Expected $ending, but found $token instead\n";
                $sum += $points{$token};
            }
        }
        else {
            print "How did we get here?\n";
            print "line is $line\n";
            print "stack: ", ddc( \@stack );
            print "token is $token\n";
        }
    }
}

print "sum is $sum\n";
