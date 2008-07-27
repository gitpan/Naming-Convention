use Test::More;
eval "use Test::Perl::Critic 1.01";
plan skip_all => "Test::Perl::Critic 1.01 required for testing PBP compliance" if $@;

Test::Perl::Critic::all_critic_ok();
