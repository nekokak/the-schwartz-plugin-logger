package TheSchwartz::Plugin::Logger::Registrar;

## logger method registrar.

package TheSchwartz::Plugin::Logger;
use strict;
use warnings;

our $VERSION = '0.01';

use Log::Dispatch;
use UNIVERSAL::require;
use Sub::Exporter -setup => {
    exports => [
        logger => \&_logger,
    ],
};

sub _logger {
    my ($class, $name, $arg) = @_;

    my $code = TheSchwartz::Plugin::Logger::Registrar->can('logger');
    $code ? $code->() : do {
        no strict 'refs'; ## no critic.
        *{"TheSchwartz::Plugin::Logger::Registrar::logger"} = sub {
            my $dispatcher = Log::Dispatch->new;

            my $class = "Log::Dispatch::$arg->{class}";
            $class->use or die $@;
            $dispatcher->add(
                $class->new(%{$arg->{conf}})
            ) or die $@;
            return $dispatcher;
        };
    };
}

1;
=head1 NAME

TheSchwartz::Plugin::Logger - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Atsushi Kobayashi 

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

