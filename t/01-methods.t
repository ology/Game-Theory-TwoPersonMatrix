use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = Game::Theory::TwoPersonMatrix->new;
isa_ok $g, 'Game::Theory::TwoPersonMatrix';

is $g->expected_value(1), 1, 'player 1 expected_value';

done_testing();
