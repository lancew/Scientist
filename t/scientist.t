use Test2::Bundle::Extended -target => 'Scientist';

use lib "t/lib";

subtest context => sub {
    my $ctx = {
        one_key    => 'first value',
        second_key => 'second value',
    };

    my $experiment = $CLASS->new(
        use => sub { 10 },
        try => sub { 20 },
        context => $ctx,
    );

    $experiment->run;

    is $experiment->result->{context}, $ctx, 'result has context';
};

subtest enabled => sub {
    my $experiment = $CLASS->new(
        use     => sub { 10 },
        enabled => 0,
    );

    my $result = $experiment->run;
    is $result, 10, 'Returns the result of the "use" code';
    is $experiment->result, undef, 'Result is not set if experiment not enabled';
};

subtest enabled_ratio => sub {
    require Lazy::Scientist;

    my %call_counts;
    my $experiment = Lazy::Scientist->new(
        use => sub { ++$call_counts{control} },
        try => sub { ++$call_counts{candidate} },
    );

    $experiment->run for 1..100;

    note "Control called  : $call_counts{control}";
    note "Candidate called: $call_counts{candidate}";

    is $call_counts{control}, 100, 'Control code always ran';
    ok $call_counts{candidate} >= 6 && $call_counts{candidate} <= 14,
        'Candidate code ran about 10% of the time';
};

subtest experiment => sub {
    is $CLASS->new->experiment, 'experiment', 'got default experiment name()';
};

subtest name => sub {
    is Scientist::name(), 'experiment', 'name() is set.';
};

subtest named_subclass => sub {
    require Named::Scientist;

    my $experiment = Named::Scientist->new;
    is $experiment->experiment, 'joe', 'inherited experiment name()';
};

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

subtest publish => sub {
    require Publishing::Scientist;

    my $experiment = Publishing::Scientist->new(
        experiment => 'publish and die',
        use        => sub { 10 },
        try        => sub { 20 },
    );

    like(
        dies { $experiment->run },
        qr/publish and die/,
        'Experiment name is in publish die statement as expected.',
    );
};

subtest random_order => sub {
    my $winner;
    my $test_thing = mock obj => (
        add => [
            control   => sub { $winner ||= 'control'   },
            candidate => sub { $winner ||= 'candidate' },
        ],
    );

    my $experiment = $CLASS->new(
        use => sub { $test_thing->control   },
        try => sub { $test_thing->candidate },
    );

    # Race 1000 times and record each winner.
    my %results;
    for (1..100) {
        $experiment->run;
        $results{$winner}++;
        undef $winner;
    }

    note "Control called first  : $results{control}";
    note "Candidate called first: $results{candidate}";

    ok $results{control} > 45,   '>40% Control code run first';
    ok $results{candidate} > 45, '>40% Candidate code run first';
};

subtest result_mismatch => sub {
    my $old = [ { foo => 1 }, { bar => 'x'   } ];
    my $new = [ { for => 1 }, { bar => 'ZZZ' } ];

    my $experiment = $CLASS->new(
        use => sub { $old },
        try => sub { $new },
    );

   my $result = $experiment->run;

   is $result, $old, 'Returns the result of the "use" code';
   ok $experiment->result->{mismatched},
       'Correctly identified a mismatch between control and candidate';
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

subtest result_match => sub {
    my $data = [ { foo => 1 }, { bar => 'x' } ];

    my $experiment = $CLASS->new(
        use => sub { $data },
        try => sub { $data },
    );

    my $result = $experiment->run;

    is $result, $data, 'Returns the result of the "use" code';
    ok !$experiment->result->{mismatched},
        'Correctly identified no mismatch between control and candidate';
};


subtest wantarray_only_control => sub {
    my @a = qw/one two three/;
    my $experiment = $CLASS->new(
        use     => sub { wantarray ? @a : "@a" },
        enabled => 0,
    );

    $experiment->run;

    my $scalar_result = $experiment->run;
    my @list_result   = $experiment->run;

    is $scalar_result, 'one two three', 'Got scalar result';
    is \@list_result, \@a, 'Got list result';
};

subtest wantarray_with_candidate => sub {
    my @a = qw/one two three/;

    my $experiment = $CLASS->new(
        use => sub { wantarray ? @a : "@a" },
        try => sub { wantarray ? @a : "@a" },
    );

    $experiment->run;

    my $scalar_result = $experiment->run;
    my @list_result   = $experiment->run;

    is $scalar_result, 'one two three', 'Got scalar result';
    is \@list_result, \@a, 'Got list result';
};

done_testing;
