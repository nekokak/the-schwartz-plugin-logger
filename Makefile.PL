use inc::Module::Install;
name 'TheSchwartz-Plugin-Logger';
all_from 'lib/TheSchwartz/Plugin/Logger.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
