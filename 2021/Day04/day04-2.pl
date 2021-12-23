#!/usr/bin env perl

STDOUT->autoflush(1);

use strict;
use warnings;

use File::Slurp;

# load data
my @data = read_file('data.txt');
chomp @data;

# Load draws
my @draws = split( /,/, shift @data );

# discard next line
shift @data;

my @boards;
my $board = [];

for my $line (@data) {
    # Trim off leading space
    $line =~ s/^\s+//;

    if ( $line =~ /\d+\s+\d+\s+\d+\s+\d+\s+\d+$/ ) {
        my $numbers = [ split( /\s+/, $line, 5 ) ];
        push @$board, $numbers;
    }

    # Process an empty line.  Add the board to the boards array
    # and reset the row_ref
    elsif ( $line =~ /^$/ ) {
        push @boards, $board;
        $board = [];
    }
}
# Push last board into array
push @boards, $board;

# Print a board nicely
sub print_board {
    my $board = shift;
    for my $row (@$board) {
        for my $spot (@$row) {
            printf "%2s ", $spot;
        }
        print "\n";
    }
}

# Find the index of all the winners and return them for
# processing
sub find_all_winners {
    my @win_indexes;
    my $nb = scalar(@boards);
    for ( my $i = 0; $i < $nb; $i++ ) {
        my $board = $boards[$i];
        my $bingo = 0;
        # Check rows
        for my $row (@$board) {
            my $xes = scalar grep { "$_" eq "X" } @$row;
            $bingo++ if $xes == 5;
        }
        # Check cols
        my $nr = scalar @{ $$board[0] };
        for ( my $j = 0; $j < $nr; $j++ ) {
            my $xes = 0;
            for ( my $ri = 0; $ri < $nr; $ri++ ) {
                $xes++ if ( "$$board[$ri][$j]" eq "X" );
            }
            $bingo++ if $xes == 5;
        }
        if ($bingo) {
            push @win_indexes, $i;
        }
    }
    return @win_indexes;
}

# Play teh game!
for ( my $di = 0; $di < scalar(@draws); $di++ ) {
    my $draw = $draws[$di];
    printf "Draw #%d is %d\n", $di, $draw;
    printf "Playing %d boards\n", scalar(@boards);

    # Play draw on all boards
    for my $board (@boards) {
        for my $row (@$board) {
            my $ri = 0;
            for my $spot (@$row) {
                if ( "$spot" eq "$draw" ) {
                    # Replace number with an 'X'
                    splice( @$row, $ri, 1, "X" );
                }
                $ri++;
            }
        }
    }

    # Did we get a winner?
    my @winners = find_all_winners();
    for my $wi (@winners) {
        my $winner = $boards[$wi];
        print "Winning board index is $wi\n";
        print "Wining board is:\n";
        print_board($winner);

        # Sum up all unmatched numbers
        my $unmatched_sum = 0;
        for my $row (@$winner) {
            for my $spot (@$row) {
                $unmatched_sum += $spot if "$spot" ne "X";
            }
        }

        # Print final score of that board
        printf "Sum of unmatched numbers * winning draw is %d\n\n",
            $unmatched_sum * $draw;
    }

    # Sort winner indexes into descending order to avoid
    # splicing nonexistent index entries.
    for my $wi ( sort { $b <=> $a } @winners ) {
        # Remove winning board
        splice( @boards, $wi, 1 );
    }

    # drop out if we run out of boards
    last unless scalar @boards > 0;
    print "\n";
}
