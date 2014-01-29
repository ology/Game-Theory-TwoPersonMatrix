use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = Game::Theory::TwoPersonMatrix->new;
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
my $x = $g->{1};
is_deeply $g->{1}, [[1,0],[0,1]], 'player 1';
is_deeply $g->{2}, [[1,0],[0,1]], 'player 2';
$x = $g->nash;
is_deeply $x->{'0,0'}, [1,1], 'nash';
is_deeply $x->{'1,1'}, [1,1], 'nash';

done_testing();
