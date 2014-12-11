package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Analyze a 2 person matrix game

use strict;
use warnings;

our $VERSION = '0.06';

=head1 SYNOPSIS

  use Game::Theory::TwoPersonMatrix;
  my $g = Game::Theory::TwoPersonMatrix->new();

=head1 DESCRIPTION

A C<Game::Theory::TwoPersonMatrix> analyzes a two person matrix game
of player names, strategies and numerical utilities.

The players must have the same number of strategies, and each strategy must have
the same size utility vectors as all the others.

Players 1 and 2 are the "row" and "column" players, respectively.  This is due
to the tabular format of a matrix game:

                  Player 2
                  --------
         Strategy 0.5  0.5
 Player |   0.5    1    0  < Utility
    1   |   0.5    0    1  <

The above is a simple, symmetrical zero-sum game, i.e. "matching pennies."

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
        payoff => $args{payoff} || [ [1,0], [0,1] ],
    };
    bless $self, $class;
    return $self;
}

=head2 expected_value()

Return the expected payoff value.

=cut

sub expected_value
{
    my ($self) = @_;

    my $expected_value = 0;
    # For each strategy of player 1...
    for my $i ( keys %{ $self->{1} } )
    {
        # For each strategy of player 2...
        for my $j ( keys %{ $self->{2} } )
        {
            # Expected value is the sum of the probabilities of each payoff
            $expected_value += $self->{1}{$i} * $self->{2}{$j} * $self->{payoff}[$i - 1][$j - 1];
        }
    }

    return $expected_value;
}

1;
__END__

=head1 SEE ALSO

"A Gentle Introduction to Game Theory"
L<http://www.amazon.com/Gentle-Introduction-Theory-Mathematical-World/dp/0821813390>

=cut
