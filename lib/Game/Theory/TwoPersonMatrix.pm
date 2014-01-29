package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Reduce and analyze two person matrix games

our $VERSION = '0.01_1';

use strict;
use warnings;

=head1 NAME

Game::Theory::TwoPersonMatrix - Reduce and analyze two person matrix games

=head1 SYNOPSIS

  use Game::Theory::TwoPersonMatrix;
  my $g = Game::Theory::TwoPersonMatrix->new(%arguments);

=head1 DESCRIPTION

A C<Game::Theory::TwoPersonMatrix> reduces and analyzes a two person matrix game.

=cut

=head1 METHODS

=head2 new()

  my $g = Game::Theory::TwoPersonMatrix->new(%arguments);

Create a new C<Game::Theory::TwoPersonMatrix> object.

Argument defaults:
  p1 = [[1,0],[0,1]]
  p2 = [[1,0],[0,1]]

Players are given by a 2D matrix of utilities (or payoffs) such that,

 [ [ u1, u2 .. un] .. [ v1, v2 .. vn ] ] 

Where each B<u>C<i> is a utility or payoff for the strategy B<U>.

=cut

sub new {
    my $class = shift;
    my %args = @_;
    my $self = {
        p1 => $args{p1} || [[1,0],[0,1]],
        p2 => $args{p2} || [[1,0],[0,1]],
    };
    bless $self, $class;
    return $self;
}

=head2 reduce()

Reduce the game by elimination of strictly dominated strategies.

=cut

sub reduce {
    my $self = shift;
}

=head2 nash()

Find the Nash equilibria.

=cut

sub nash {
    my $self = shift;
}

1;
__END__

=cut
