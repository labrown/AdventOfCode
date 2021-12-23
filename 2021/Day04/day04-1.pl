#!/usr/bin env perl

use strict;
use warnings;

use File::Slurp;
use Data::Dumper::Simple;

# load data
my @data = read_file('data.txt');
chomp @data;

# Load draws
my @draws = split( /,/, shift @data );

# discard next line
shift @data;

my @boards;

my $row_ref = [];
my $col_ref = [ [], [], [], [], [] ];

for my $line (@data) {

    # Process a board line
    if ( $line =~ /^\d+\s+\d+\s+\d+\s+\d+\s+\d+$/ ) {
        my @numbers = split( /\s+/, $line, 5 );
        my @row     = map { { number => $_, played => 0 } } @numbers;
        push @$row_ref, \@row;
        for ( my $i = 0; $i < scalar(@row); $i++ ) {
            my $aref = @$col_ref[$i];
            push @$aref, $row[$i];
        }
    }

    # Process an empty line.  Add the board to the boards array
    # and reset the row_ref
    elsif ( $line =~ /^$/ ) {
        push @boards, $row_ref;
        push @boards, $col_ref;
        $row_ref = [];
        $col_ref = [ [], [], [], [], [] ];
    }
}
push @boards, $row_ref;
push @boards, $col_ref;

sub print_board {
    my $board = shift;
    for my $row (@$board) {
        for my $spot (@$row) {
            printf "%2d%s ", $$spot{number}, $$spot{played} ? 'X' : " ";
        }
        print "\n";
    }
}

sub find_winner {
    my $winner = undef;

    for my $board (@boards) {
        for my $row (@$board) {
            my $bingo = scalar grep { $_->{played} == 1 } @$row;
            if ( $bingo == 5 ) {
                $winner = $board;
            }
        }
        last if $winner;
    }

    return $winner;
}

# Run the draws
my $winner;
my $winning_draw;
for my $draw (@draws) {
    for my $board (@boards) {
        for my $row (@$board) {
            for my $spot (@$row) {
                if ( $$spot{number} == $draw ) {
                    $$spot{played} = 1;
                }
            }
        }
    }
    $winner       = find_winner();
    $winning_draw = $draw;
    last if $winner;
}

print "Winning draw is $winning_draw\n";
print "Wining board is:\n";
print_board($winner);

my $unmatched_sum = 0;
for my $row (@$winner) {
    for my $spot (@$row) {
        $unmatched_sum += $$spot{number} if $$spot{played} == 0;
    }
}

printf "Unmatched numbers * winning draw is %d\n",
    $unmatched_sum * $winning_draw;
