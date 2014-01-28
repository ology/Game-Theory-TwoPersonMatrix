use Test::More;
use_ok 'Game::Theory::TwoPersonMatrix';

my $g = eval { Game::Theory::TwoPersonMatrix->new };
isa_ok $g, 'Game::Theory::TwoPersonMatrix';
ok !$@, 'created with no arguments';

my $x = $g->{foo};
is $x, 'bar', "foo: $x";

$g = Game::Theory::TwoPersonMatrix->new(
    foo => 'Zap!',
);
$x = $g->{foo};
like $x, qr/zap/i, "foo: $x";

done_testing();
