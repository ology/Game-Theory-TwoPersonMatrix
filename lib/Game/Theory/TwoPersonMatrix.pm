package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Analyze a 2 person matrix game

use strict;
use warnings;

use Carp;
use Algorithm::Combinatorics qw( permutations );
use List::Util qw( max min );
use List::MoreUtils qw( zip );

our $VERSION = '0.10';

=head1 SYNOPSIS

 use Game::Theory::TwoPersonMatrix;
 my $g = Game::Theory::TwoPersonMatrix->new();
 $g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => 0.2, 2 => 0.3, 3 => 0.5 },
    2 => { 1 => 0.1, 2 => 0.7, 3 => 0.2 },
    payoff => [ [ 0, 1,-1],
                [-1, 0, 1],
                [ 1,-1, 0] ]
 };
 $g->expected_payoff();
 $g->counter_strategy($player);

=head1 DESCRIPTION

A C<Game::Theory::TwoPersonMatrix> analyzes a two person matrix game
of player names, strategies and utilities.

The players must have the same number of strategies, and each strategy must have
the same size utility vectors as all the others.

Players 1 and 2 are the "row" and "column" players, respectively.  This is due
to the tabular format of a matrix game:

                  Player 2
                  --------
         Strategy 0.5  0.5
 Player |   0.5    1   -1  < Payoff
    1   |   0.5   -1    1  <

The above is the default - a symmetrical zero-sum game.

=cut

=head1 METHODS

=head2 new()

 $g = Game::Theory::TwoPersonMatrix->new();
 $g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.5', 2 => '0.5' },
    2 => { 1 => '0.5', 2 => '0.5' },
    payoff => [ [1,0],
                [0,1] ]
 );

Create a new C<Game::Theory::TwoPersonMatrix> object.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        1 => $args{1} || { 1 => '0.5', 2 => '0.5' },
        2 => $args{2} || { 1 => '0.5', 2 => '0.5' },
        payoff => $args{payoff} || [ [1,-1], [-1,1] ],
    };
    bless $self, $class;
    return $self;
}

=head2 expected_payoff()

 $g->expected_payoff();

Return the expected payoff value of the game.

=cut

sub expected_payoff
{
    my ($self) = @_;

    my $expected_payoff = 0;
    # For each strategy of player 1...
    for my $i ( sort { $a <=> $b } keys %{ $self->{1} } )
    {
        # For each strategy of player 2...
        for my $j ( sort { $a <=> $b } keys %{ $self->{2} } )
        {
            # Expected value is the sum of the probabilities of each payoff
            $expected_payoff += $self->{1}{$i} * $self->{2}{$j} * $self->{payoff}[$i - 1][$j - 1];
        }
    }

    return $expected_payoff;
}

=head2 s_expected_payoff()

 $g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '(1 - p)', 2 => 'p' },
    2 => { 1 => 1, 2 => 0 },
    payoff => [ ['a','b'], ['c','d'] ]
 );
 $g->s_expected_payoff();

Return the expected payoff expression for a non-numeric game.

Using real payoff values, we solve the resulting expression for p in the F<eg/>
examples.

=cut

sub s_expected_payoff
{
    my ($self) = @_;

    my $expected_payoff = '';
    # For each strategy of player 1...
    for my $i ( sort { $a <=> $b } keys %{ $self->{1} } )
    {
        # For each strategy of player 2...
        for my $j ( sort { $a <=> $b } keys %{ $self->{2} } )
        {
            # Expected value is the sum of the probabilities of each payoff
            $expected_payoff .= " + $self->{1}{$i} * $self->{2}{$j} * $self->{payoff}[$i - 1][$j - 1]";
        }
    }

    $expected_payoff =~ s/^ \+ (.+)$/$1/g;

    return $expected_payoff;
}

=head2 counter_strategy()

 $g->counter_strategy($player);

Return the counter-strategies for a given player.

=cut

sub counter_strategy
{
    my ( $self, $player ) = @_;

    my $counter_strategy = [];
    my %seen;

    my $opponent = $player == 1 ? 2 : 1;

    my @keys = 1 .. keys %{ $self->{$player} };
    my @pure = ( 1, (0) x ( keys( %{ $self->{$player} } ) - 1 ) );

    my $i = permutations( \@pure );
    while ( my $x = $i->next )
    {
        next if $seen{"@$x"}++;

        my $g = Game::Theory::TwoPersonMatrix->new(
            $player   => { zip @keys, @$x },
            $opponent => $self->{$opponent},
            payoff    => $self->{payoff},
        );

        push @$counter_strategy, $g->expected_payoff();
    }

    return $counter_strategy;
}

=head2 saddlepoint()

 $v = $g->saddlepoint;

If the game is strictly determined, the saddlepoint is returned.  Otherwise
C<undef> is returned.

=cut

sub saddlepoint
{
    my ($self) = @_;

    my $saddlepoint;
    my $size = @{ $self->{payoff}[0] } - 1;

    # Look for saddlepoints!
    POINT:
    for my $row ( 0 .. $size )
    {
        # Get the minimum value of the current row
        my $min = min @{ $self->{payoff}[$row] };

        # Inspect each column given the row
        for my $col ( 0 .. $size )
        {
            # Get the payoff
            my $val = $self->{payoff}[$row][$col];

            # Is the payoff also the row minimum?
            if ( $val == $min )
            {
                # Gather the column values for each row
                my @col;
                for my $r ( 0 .. $size )
                {
                    push @col, $self->{payoff}[$r][$col];
                }
                # Get the maximum value of the columns
                my $max = max @col;

                # Is the payoff also the column maximum?
                if ( $val == $max )
                {
                    $saddlepoint = $val;
                    last POINT;
                }
            }
        }
    }

    return $saddlepoint;
}

=head2 oddments()

Return each player's "oddments" for a 2x2 game.

=cut

sub oddments
{
    my ($self) = @_;

    my $rsize = @{ $self->{payoff}[0] };
    my $csize = @{ $self->{payoff} };
    carp 'Payoff matrix must be 2x2' unless $rsize == 2 && $csize == 2;

    my ( $player, $opponent );

    my ( $x, $y );
    $x = $self->{payoff}[1][1] - $self->{payoff}[1][0];
    $y = $self->{payoff}[0][0] - $self->{payoff}[0][1];
    if ( $x < 0 || $y < 0 )
    {
        $x = $self->{payoff}[1][0] - $self->{payoff}[1][1];
        $y = $self->{payoff}[0][1] - $self->{payoff}[0][0];
    }
    my $i = $x / ( $x + $y );
    my $j = $y / ( $x + $y );
    $player = [ $i, $j ];

    $x = $self->{payoff}[1][1] - $self->{payoff}[0][1];
    $y = $self->{payoff}[0][0] - $self->{payoff}[1][0];
    if ( $x < 0 || $y < 0 )
    {
        $x = $self->{payoff}[0][1] - $self->{payoff}[1][1];
        $y = $self->{payoff}[1][0] - $self->{payoff}[0][0];
    }
    $i = $x / ( $x + $y );
    $j = $y / ( $x + $y );
    $opponent = [ $i, $j ];

    return [ $player, $opponent ];
}

1;
__END__

=head1 SEE ALSO

"A Gentle Introduction to Game Theory"

L<http://www.amazon.com/Gentle-Introduction-Theory-Mathematical-World/dp/0821813390>

L<http://books.google.com/books?id=8doVBAAAQBAJ>

=cut
