package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Reduce and analyze two person matrix games

our $VERSION = '0.01_1';

use strict;
use warnings;

=head1 NAME

Game::Theory::TwoPersonMatrix - Reduce and analyze two person matrix games

=head1 SYNOPSIS

  use Game::Theory::TwoPersonMatrix;
  $x = Game::Theory::TwoPersonMatrix->new(%arguments);

=head1 DESCRIPTION

A C<Game::Theory::TwoPersonMatrix> ...Why?

=cut

=head1 METHODS

=head2 new()

  $x = Game::Theory::TwoPersonMatrix->new(%arguments);

Create a new C<Game::Theory::TwoPersonMatrix> object.

Arguments and defaults:
  foo => bar,
  abc => 123,

=cut

sub new {
    my $class = shift;
    my %args = @_;
    # Explicit constructor:
    my $self = {
        foo => $args{foo} || undef,
        %args # Final override.
    };
    bless $self, $class;
    $self->_init(%args);
    return $self;
}
sub _init {
    my ($self, %args) = @_;
    $self->{foo} ||= 'bar';
    $self->{abc} ||= 123;
}

1;
__END__

=cut
