use Test2::Bundle::Extended -target => 'Scientist';

use lib "t/lib";

subtest new => sub {
    ok $CLASS->new, 'new()';
};

subtest result => sub {
    my $experiment = $CLASS->new(
        use => sub { 10 },
        try => sub { 20 },
    );

    my $result = $experiment->run;

    is $result, 10, 'Returns the result of the "use" code';
};

subtest result_duration => sub {
    my $experiment = $CLASS->new(
        use => sub { 10 },
        try => sub { 20 },
    );

    $experiment->run;

    ok $experiment->result->{control}{duration} > 0,
        'Returns duration timing of control';

    ok $experiment->result->{candidate}{duration} > 0,
        'Returns duration timing of candidate';
};

subtest result_observation => sub {
    my $experiment = $CLASS->new(
        use => sub { 10 },
        try => sub { 20 },
    );

    $experiment->run;

    is $experiment->result->{observation}{candidate},
        20,
        'Observation candidate data correct';

    is $experiment->result->{observation}{control},
        10,
        'Observation control data correct';

    is $experiment->result->{observation}{diagnostic},
        ( "+------+-----+----+-------+\n"
        . "| PATH | GOT | OP | CHECK |\n"
        . "+------+-----+----+-------+\n"
        . "| [0]  | 20  | eq | 10    |\n"
        . "+------+-----+----+-------+" ),
        'Observation diagnostic correct';
};

done_testing;
