use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = Game::Theory::TwoPersonMatrix->new;
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
is $g->expected_payoff(), 0, 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.2', 2 => '0.8' },
    2 => { 1 => '0.3', 2 => '0.7' },
    payoff => [ [5,0], [-1,2] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '2x2';
is $g->expected_payoff(), 1.18, 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.2', 2 => '0.3', 3 => '0.5' },
    2 => { 1 => '0.1', 2 => '0.7', 3 => '0.2' },
    payoff => [ [ 0, 1,-1],
                [-1, 0, 1],
                [ 1,-1, 0],
    ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '3x3';
is $g->expected_payoff(), -0.17, 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.3', 2 => '0',   3 => '0.7' },
    2 => { 1 => '0.1', 2 => '0.2', 3 => '0.3', 4 => '0.4' },
    payoff => [ [2,-1,-5, 3],
                [0,-2, 3,-3],
                [1, 0, 1,-2],
    ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '3x4';
is $g->expected_payoff(), -0.37, 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => 'p', 2 => '1 - p' },
    2 => { 1 => 'q', 2 => '1 - q' },
    payoff => [ ['a','b'], ['c','d'] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', 'symbolic';
is $g->s_expected_payoff(), 'p * q * a + p * 1 - q * b + 1 - p * q * c + 1 - p * 1 - q * d', 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.5', 2 => '0.5' },
    2 => { 1 => 'q', 2 => '1 - q' },
    payoff => [ [1,0], [0,1] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', 'symbolic';
is $g->s_expected_payoff(), '0.5 * q * 1 + 0.5 * 1 - q * 0 + 0.5 * q * 0 + 0.5 * 1 - q * 1', 'expected_payoff';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => '0.2', 2 => '0.3', 3 => '0.5' },
    2 => { 1 => '0.1', 2 => '0.7', 3 => '0.2' },
    payoff => [ [ 0, 1,-1],
                [-1, 0, 1],
                [ 1,-1, 0],
    ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '3x3';
is_deeply $g->counter_strategy(2), [ 0.2, -0.3, 0.1 ], 'player 2 counter_strategy';

$g = Game::Theory::TwoPersonMatrix->new(
    payoff => [ [0,-1],
                [2, 3] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '2x2';
is $g->saddlepoint, 2, 'saddlepoint';

$g = Game::Theory::TwoPersonMatrix->new(
    payoff => [ [ 9,-2,-5],
                [ 5, 1,-9],
                [ 3, 2, 5],
                [-5, 0, 1] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '4x3';
is $g->saddlepoint, 2, 'saddlepoint';

$g = Game::Theory::TwoPersonMatrix->new(
    payoff => [ [5,-2],
                [1, 4] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '2x2';
is_deeply $g->oddments, [ [ 0.3, 0.7 ], [ 0.6, 0.4 ] ], 'oddments';

$g = Game::Theory::TwoPersonMatrix->new(
    payoff => [ [-5, 4, 6],
                [ 3,-2, 2],
                [ 2,-3, 1] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '3x3';
is_deeply $g->row_reduce, [ [-5,4,6],[3,-2,2] ], 'row_reduce';
is_deeply $g->col_reduce, [ [-5,4],[3,-2] ], 'col_reduce';

$g = Game::Theory::TwoPersonMatrix->new(
    1 => { 1 => 0.1, 2 => 0.2, 3 => 0.3, 4 => 0.4 },
    2 => { 1 => 0.2, 2 => 0.3, 3 => 0.4, 4 => 0.1 },
    payoff => [ [ 3,-2, 2, 1],
                [ 1,-2, 2, 0],
                [ 0, 6, 0, 7],
                [-1, 5, 0, 8] ]
);
isa_ok $g, 'Game::Theory::TwoPersonMatrix', '4x4';
is_deeply $g->col_reduce, [ [3,-2,2 ],[1,-2,2],[0,6,0],[-1,5,0] ], 'col_reduce';
is_deeply $g->row_reduce, [ [3,-2,2],[0,6,0] ], 'row_reduce';
is_deeply $g->col_reduce, [ [-2,2],[6,0] ], 'col_reduce';
use Data::Dumper::Concise;print Dumper($g);

done_testing();
