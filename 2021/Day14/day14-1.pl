#!/usr/bin/env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Compact 'ddc';

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
sub get_pairs {
    my $template = shift;

    my @pairs;
    my $tl = length($template);
    for ( my $i = 0; $i < $tl - 1; $i++ ) {
        push @pairs, substr( $template, $i, 2 );
    }
    return @pairs;
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
## MAIN
#####################################################################

my $template = get_template( \@data );
my $rules    = get_rules( \@data );

# print "template is $template\n";
# print "rules are ", ddc($rules);

for ( my $step = 1; $step <= 10; $step++ ) {
    # split template into pairs
    my @pairs = get_pairs($template);
    # print "pairs are ", join( ",", @pairs ), "\n";
    $template = insert_pairs( $template, $rules, @pairs );
    # print "template is $template\n";
    # print "\n";
}

my %counts;
foreach my $char ( split //, $template ) { $counts{$char}++ }

my @sorted_sizes = sort { $a <=> $b } values(%counts);

print "result is ", $sorted_sizes[$#sorted_sizes] - $sorted_sizes[0], "\n";

