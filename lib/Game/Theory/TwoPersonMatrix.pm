package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Analyze a 2 person matrix game

use strict;
use warnings;

our $VERSION = '0.06_01';

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
        1 => {
            1 => { probability => '0.5', payoff => [1,0] },
            2 => { probability => '0.5', payoff => [0,1] },
        },
        2 => {
            1 => { probability => '0.5', payoff => [1,0] },
            2 => { probability => '0.5', payoff => [0,1] },
        },
  );

Create a new C<Game::Theory::TwoPersonMatrix> object.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        1 => $args{1} || {
            1 => { probability => '0.5', payoff => [1,0] },
            2 => { probability => '0.5', payoff => [0,1] },
        },
        2 => $args{2} || {
            1 => { probability => '0.5', payoff => [1,0] },
            2 => { probability => '0.5', payoff => [0,1] },
        },
    };
    bless $self, $class;
    return $self;
}

sub expected_value
{
    my ( $self, $player ) = @_;
    my $expected_value = 0;
    # TODO
    return $expected_value;
}

1;
__END__

=head1 SEE ALSO

"A Gentle Introduction to Game Theory"
L<http://www.amazon.com/Gentle-Introduction-Theory-Mathematical-World/dp/0821813390>

=cut
