use strict;
use warnings;
use TheSchwartz::Test;

use Test::More tests => 8;
use Test::Output;

run_tests(4, sub {
    my $client = test_client(
        dbs      => ['ts1'],
        dbprefix => 'nekortz',
    );

    for ( 1..2 ) {
        my $handle = $client->insert("Worker::Test", { numbers => [1, 2] });
        isa_ok $handle, 'TheSchwartz::JobHandle', "inserted job";

        $client->can_do('Worker::Test');
        stdout_is( sub { $client->work_once } , "Worker::Test: worked!\n");
    }

    teardown_dbs();
});

package Worker::Test;
use base 'TheSchwartz::Worker';
use TheSchwartz::Plugin::Logger
    logger => {
        class => 'Screen',
        conf  => {
            name      => 'TestLogger',
            min_level => 'debug',
            stderr    => 0,
        },
    },
;

sub work {
    my ($class, $job) = @_;
    logger->log(level => 'debug', message => "Worker::Test: worked!\n");
}
