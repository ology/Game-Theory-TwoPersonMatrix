package Game::Theory::TwoPersonMatrix;

# ABSTRACT: Reduce and analyze two person matrix games

our $VERSION = '0.01_1';

use strict;
use warnings;

use Data::Dumper;
use Algorithm::Combinatorics qw( variations_with_repetition );
use List::Util qw( max );
use List::MoreUtils qw( all indexes each_array );

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

    # Convenience:
    my ($player, $opponent) = ($self->{p1}, $self->{p2});

    # Declare the bucket of "X given Y" strategy pair utilities.
    my $utility = {};
    my $metric  = {};

    # Evaluate pairs of strategies.
    my $iter = variations_with_repetition([keys %$player], 2);
    while (my $v = $iter->next) {
        # Skip "X|X" pairs.
        next if $v->[0] eq $v->[1];

        # Inspect each stategy utility.
        #warn join(', ', @$v), "\n";
        for my $i (0 .. @$v - 1) {
            # Only consider defined utilities.
            if (defined $player->{$v->[0]}[$i] && defined $player->{$v->[1]}[$i]) {
                #warn "$i: $player->{$v->[0]}[$i] vs $player->{$v->[1]}[$i]\n";

                # Add a relative utility indicator.
                if ($player->{$v->[0]}[$i] > $player->{$v->[1]}[$i]) {
                    # Strictly dominant utility
                    push @{ $utility->{join '|', @$v} }, 1;
                }
                elsif ($player->{$v->[0]}[$i] < $player->{$v->[1]}[$i]) {
                    # Strictly dominated utility
                    push @{ $utility->{join '|', @$v} }, -1;
                }
                else {
                    # Equivalent utility
                    push @{ $utility->{join '|', @$v} }, 0;
                }

                # Track the actual relative utility metric.
                #push @{ $metric->{join '|', @$v} }, $player->{$v->[0]}[$i] - $player->{$v->[1]}[$i];
            }
        }
    }

    # Remove a strictly dominated strategy.
    for my $strat (keys %$utility) {
        if (all { $_ == -1 } @{$utility->{$strat}}) {
            #warn "U:[@{$utility->{$strat}}]\n";

            # Capture the strategies.
            my @dominated = split /\|/, $strat;
            #warn "D:'$dominated[0]'\n";

            # Remove the S.D. strategy.
            delete $player->{$dominated[0]};

            # Remove the utilities for the deleted opponent strategy.
            for my $u (keys %$opponent) {
                splice @{$opponent->{$u}}, $dominated[0] - 1, 1;
                #warn "u:'@{$opponent->{$u}}'\n";
            }

            # Currently, we only reduce by a single strategy.
            last;
        } 
    }

    return $player, $opponent;
}

=head2 nash()

Find the Nash equilibria.

=cut

sub nash {
    my $self = shift;

    # Convenience:
    my ($player, $opponent) = ($self->{p1}, $self->{p2});

    # Inspect each player item for best strategy.
    my %x; # Max utility indexes.

    # Get the best strategies of the player.
    for my $u ( sort { $a <=> $b } keys %$player ) {
        # Find the maximum utility for the strategy.
        my $max = max @{ $player->{$u} };

        # Get the "strategically most desirable" indexes.
        $x{$u} = [ indexes { $_ >= $max } @{ $player->{$u} } ];
    }

    # Inspect each opponent item for best strategy...
    my %y;
    for my $u ( sort { $a <=> $b } keys %$opponent ) {
        my $max = max @{ $opponent->{$u} };
        $y{$u} = [ indexes { $_ >= $max } @{ $opponent->{$u} } ];
    }
    #warn 'X:',Data::Dumper->new([\%x])->Indent(1)->Terse(1)->Quotekeys(0)->Sortkeys(1)->Dump;
    #warn 'Y:',Data::Dumper->new([\%y])->Indent(1)->Terse(1)->Quotekeys(0)->Sortkeys(1)->Dump;

    # Identify the Nash equilibria.
    my $nash = {};

    # Inspect index pairs of strategies.
    my @xstrat = sort { $a <=> $b } keys %x;
    my @ystrat = sort { $a <=> $b } keys %y;
    my $estrat = each_array(@xstrat, @ystrat);
    while ( my ($xs, $ys) = $estrat->() ) {
        #warn "xs:'@{$x{$xs}}'\n";
        #warn "ys:'@{$y{$ys}}'\n";

        # Inspect index pairs of utilities.
        my $eutil = each_array(@{$x{$xs}}, @{$y{$ys}});
        while ( my ( $i, $j ) = $eutil->() ) {
            # Are the best strategies for both players on the same coordinate?
            if ( $i == $j ) {
                #warn "$xs,$ys: $i == $j\n";

                # Save the strategy coordinate and utilities.
                $nash->{"$xs,$ys"} = [ $player->{$xs}[$i], $opponent->{$ys}->[$j] ];
            }
        }
    }

    return $nash;

}

1;
__END__

=cut
