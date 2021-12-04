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

my @row_boards;
my @col_boards;

my $row_ref = [];
my $col_ref = [ [], [], [], [], [] ];

for my $line (@data) {

    # Process a board line
    #print "line is >$line<\n";

    # Trim off leading space
    $line =~ s/^\s+//;

    if ( $line =~ /\d+\s+\d+\s+\d+\s+\d+\s+\d+$/ ) {
        my @numbers = split( /\s+/, $line, 5 );
        my @row     = map { { number => $_, played => 0 } } @numbers;
        push @$row_ref, \@row;
        for ( my $i = 0; $i < scalar(@row); $i++ ) {
            my $aref = @$col_ref[$i];
            push @$aref, { number => $row[$i]->{number}, played => 0 };
        }
    }

    # Process an empty line.  Add the board to the boards array
    # and reset the row_ref
    elsif ( $line =~ /^$/ ) {
        push @row_boards, $row_ref;
        push @col_boards, $col_ref;
        $row_ref = [];
        $col_ref = [ [], [], [], [], [] ];
    }
}
push @row_boards, $row_ref;
push @col_boards, $col_ref;

# print Dumper(@row_boards);
# print Dumper(@col_boards);

sub print_board {
    my $board = shift;
    for my $row (@$board) {
        for my $spot (@$row) {
            printf "%2d%s ", $$spot{number}, $$spot{played} ? 'X' : " ";
        }
        print "\n";
    }
}

sub find_all_winner {
    my $num_winners = 0;
    for ( my $i = 0; $i < scalar(@row_boards); $i++ ) {
        for my $board ( $row_boards[$i], $col_boards[$i] ) {
            for my $row (@$board) {
                my $bingo = scalar grep { $_->{played} == 1 } @$row;
                if ( $bingo == 5 ) {
                    $num_winners++;
                }

            }
        }
    }
    print "num_winners is $num_winners\n";
}

sub find_winner {
    for ( my $i = 0; $i < scalar(@row_boards); $i++ ) {
        for my $board ( $row_boards[$i], $col_boards[$i] ) {
            for my $row (@$board) {
                my $bingo = scalar grep { $_->{played} == 1 } @$row;
                if ( $bingo == 5 ) {
                    return ( $board, $i );
                }

            }
        }
    }
    return ( undef, undef );
}

# print Dumper(@row_boards);
# print Dumper(@col_boards);

# Run the draws
for ( my $di = 0; $di < scalar(@draws); $di++ ) {

    my $draw = $draws[$di];
    printf "Draw %3d is %d\n", $di, $draw;

    printf "Playing %d boards\n", scalar(@row_boards);

    # Play draw on all boards
    for my $board ( @row_boards, @col_boards ) {
        for my $row (@$board) {
            for my $spot (@$row) {
                if ( $$spot{number} == $draw ) {
                    $$spot{played} = 1;
                }
            }
        }
    }

    # Did we get a winner?
    find_all_winner();
    my ( $winner, $board_index ) = find_winner();
    if ($winner) {
        print "Winning draw is $draw\n";
        print "Winning board index is $board_index\n";
        print "Wining board is:\n";
        print_board($winner);

        my $unmatched_sum = 0;
        for my $row (@$winner) {
            for my $spot (@$row) {
                $unmatched_sum += $$spot{number} if $$spot{played} == 0;
            }
        }

        printf "Unmatched numbers * winning draw is %d\n",
            $unmatched_sum * $draw;

        print "\n\n";

        # Remove winning board from boards arrays
        splice( @row_boards, $board_index, 1 );
        splice( @col_boards, $board_index, 1 );

        #print "after splice\n";
        #print Dumper(@row_boards);
        #print Dumper(@col_boards);

    }

    # drop out if we run out of boards
    last unless scalar @row_boards;
}
