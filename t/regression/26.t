use Test2::Bundle::Extended -target => 'Scientist';
# Test that we are not unintentionally exporting methods into namespace.

todo "Will fail till we clean the namespace" => sub {
    unlike(
        dies {
            my $experiment = $CLASS->new( use => sub {}, try => sub { die } );
            $experiment->time;
        },
        qr/Usage: Time::HiRes::time()/,
        "If namespace polluted"
    );

    like(
        dies {
            my $experiment = $CLASS->new( use => sub {}, try => sub { die } );
            $experiment->time;
        },
        qr/Can't locate object method "time" via package "Scientist"/,
        "Name space is clean"
    );
};
done_testing;
