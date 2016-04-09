use Test2::Bundle::Extended -target => 'Scientist';
# Test that we are not unintentionally exporting methods into namespace.

# Initial problem identified was that Time::Hires exported "time"
# this test proves it no longer does.
ok( !$CLASS->can("time"), 'should not have time()' );

# This test cribbed from WebDriver::Tiny is a be more exhaustive
# FIXME: Can we use $CLASS?
use Scientist;
is [ sort keys %Scientist:: ], [
    qw/
        BEGIN
        ISA
        VERSION
        __ANON__
        __NAMESPACE_CLEAN_STORAGE
        can
        context
        enabled
        experiment
        import
        name
        new
        publish
        result
        run
        time
        try
        use
        /
    ],
    'Scientist Name space is clean as expected';

done_testing;
