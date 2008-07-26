use strict;
use warnings;

use Test::More tests => 45;    # last test to print

use Naming::Convention qw/naming renaming default_convention
  default_keep_uppers/;

my @words     = qw/foo bar baz/;
my @words_mix = qw/FIRST fOo BAR baZ/;

# test for default_convention
is( default_convention, '_',                 'default convention is _' );
is( naming(@words),     'foo_bar_baz',       "naming @words" );
is( naming(@words_mix), 'first_foo_bar_baz', "naming @words_mix" );

is( default_convention('-'), '-', 'set default convention to -' );
is( naming(@words), 'foo-bar-baz', "naming @words" );
is( naming(@words_mix), 'first-foo-bar-baz', "naming @words_mix" );

# test naming, with option hashref
my $map = {
    '_' => {
        'foo_bar_baz'       => \@words,
        'first_foo_bar_baz' => \@words_mix,
    },
    '-' => {
        'foo-bar-baz'       => \@words,
        'first-foo-bar-baz' => \@words_mix,
    },
    UpperCamelCase => {
        'FooBarBaz'      => \@words,
        'FIRSTFooBARBaz' => \@words_mix,
    },
    lowerCamelCase => {
        'fooBarBaz'      => \@words,
        'firstFooBARBaz' => \@words_mix,
    },
};

for my $convention ( keys %$map ) {
    for my $name ( keys %{ $map->{$convention} } ) {
        my $words = $map->{$convention}{$name};
        is( naming( @$words, { convention => $convention } ),
            $name, "naming @$words with $convention" );
    }
}

ok( default_keep_uppers, 'default keep uppers is true' );
is( default_keep_uppers(undef), undef, 'set default keep upper to be undef' );
is( naming( @words_mix, { convention => 'UpperCamelCase' } ),
    'FirstFooBarBaz', "naming @words_mix with UpperCamelCase" );
is( naming( @words_mix, { convention => 'lowerCamelCase' } ),
    'firstFooBarBaz', "naming @words_mix with lowerCamelCase" );

# renaming test

my $renaming_map = {
    '_ to -'                           => { 'foo_bar_baz' => 'foo-bar-baz' },
    '_ to UpperCamelCase'              => { 'foo_bar_baz' => 'FooBarBaz' },
    '_ to lowerCamelCase'              => { 'foo_bar_baz' => 'fooBarBaz' },
    '- to UpperCamelCase'              => { 'foo-bar-baz' => 'FooBarBaz' },
    '- to lowerCamelCase'              => { 'foo-bar-baz' => 'fooBarBaz' },
    'UpperCamelCase to lowerCamelCase' => { 'FooBarBaz'   => 'fooBarBaz' },
};

for my $comment ( keys %$renaming_map ) {
    my ( $from, $to ) = $comment =~ /(\S+) to (\S+)/;
    for ( my ( $in, $out ) = each %{ $renaming_map->{$comment} } ) {
        is( renaming( $in, { convention => $to } ),
            $out, "renaming $in with $to will get $out" );
        is( renaming( $out, { convention => $from } ),
            $in, "renaming $out with $from will get $in" );
    }
}

is( renaming( 'FOOBarBaz', { convention => 'lowerCamelCase' } ), 'fooBarBaz',
'renaming FooBarBaz with lowerCamelCase will get fooBarBaz' );

is( default_convention( '_' ), '_', 'set default convention to _' );
is( renaming( 'FOOBarBaz' ), 'foo_bar_baz',
'renaming FooBarBaz with default convention will get foo_bar_baz' );

