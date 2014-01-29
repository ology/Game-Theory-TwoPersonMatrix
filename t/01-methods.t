use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = eval { Game::Theory::TwoPersonMatrix->new };
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
ok !$@, 'created with no arguments';

my $x = $g->{1};
is_deeply $g->{1}, [[1,0],[0,1]], 'player 1';
is_deeply $g->{2}, [[1,0],[0,1]], 'player 2';

done_testing();
