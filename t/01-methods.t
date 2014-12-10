use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = Game::Theory::TwoPersonMatrix->new;
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
is_deeply $g->player_strategy(1), { 1 => [ 1, 0 ], 2 => [ 0, 1 ] }, 'player 1 strategy';
is_deeply $g->player_strategy(2), { 1 => [ 1, 0 ], 2 => [ 0, 1 ] }, 'player 2 strategy';
is_deeply $g->player_choice(1), { 1 => 0.5, 2 => 0.5 }, 'player 1 choice';
is_deeply $g->player_choice(2), { 1 => 0.5, 2 => 0.5 }, 'player 2 choice';
my $x = $g->nash;
is_deeply $x->{'1,1'}, [1,1], 'nash @ 1,1';
is_deeply $x->{'2,2'}, [1,1], 'nash @ 2,2';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { strategy=>{1=>[1,1,3], 2=>[0,0,3], 3=>[0,2,5]}, },
    2 => { strategy=>{1=>[0,2,2], 2=>[3,1,4], 3=>[0,0,3]}, }
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
#use Data::Dumper::Concise;warn Dumper$g->player_play(1);
$g->reduce(2, 1);
$g->reduce(1, 2);
$g->reduce(2, 1);
$g->reduce(1, 2);
$x = $g->nash;
is_deeply $x->{'3,2'}, [2,4], 'nash @ 3,2';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { strategy=>{1=>[-1, 0], 2=>[0,  0]} },
    2 => { strategy=>{1=>[-1,-1], 2=>[-1,-1]} },
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
my $x = $g->nash;
is_deeply $x->{'2,2'}, [0,-1], 'nash @ 2,2';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { strategy=>{1=>[0,3], 2=>[2,1]} },
    2 => { strategy=>{1=>[3,0], 2=>[1,2]} }
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix';

my $p = $g->mixed;
is $p->[0], '3*(1 - q) - 2*q - 1*(1 - q)', 'player A mixed';
is $p->[1], '3*p + 1 - p - 2*(1 - p)', 'player B mixed';

done_testing();
