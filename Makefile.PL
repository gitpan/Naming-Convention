use inc::Module::Install;

name     'Naming-Convention';
all_from 'lib/Naming/Convention.pm';
author   'sunnavy <sunnavy@bestpractical.com>';

build_requires 'Test::More';

auto_install;

WriteAll;

