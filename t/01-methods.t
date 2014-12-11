use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = Game::Theory::TwoPersonMatrix->new;
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
is $g->expected_value(), 0.5, 'expected_value';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.2', 2 => '0.8' },
    2 => { 1 => '0.3', 2 => '0.7' },
    payoff => [ [ 5,0], [-1,2] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
is $g->expected_value(), 1.18, 'expected_value';

done_testing();
