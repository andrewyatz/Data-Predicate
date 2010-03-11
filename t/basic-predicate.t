package One;
use Mouse;
has 'val' => ( isa => 'Int', is => 'ro' );
no Mouse;

package Two;
use Mouse;
extends 'One';
no Mouse;

package main;

use strict;
use warnings;
use Test::More tests => 13;
use Data::Predicate::Predicates qw(:all);

{
  my $p = p_and( p_defined(), p_is_number());
  ok($p->apply(1), 'Checking the predicate understands a number');
  ok(!$p->apply('hello'), 'Checking the predicate understands a string');
  ok(!$p->apply(undef), 'Checking the predicate understands an undefined number');
  
  my @list = ('a', 1, 'b', undef, 2, 3, One->new());
  my $numbers = $p->filter(\@list);
  is_deeply($numbers, [1,2,3], 'Checking the filter system works');
  
  $numbers = $p->filter_transform(\@list, sub { return $_[0]*2 });
  is_deeply($numbers, [2,4,6], 'Checking the filter transform system works');
}

ok(p_always_true()->apply(), 'Checking always true');
ok(p_not(p_always_false())->apply(), 'Checking reverse of always false is true');

ok(!p_always_false()->apply(), 'Checking always false');
ok(!p_not(p_always_true())->apply(), 'Checking reverse of always true is false');

ok(p_ref_type('ARRAY')->apply([]), 'Checking is_ref_type is okay for arrays');

ok(p_isa('One')->apply(Two->new()), 'Checking our Object inherits correctly using isa');
ok(!p_isa('EGUtils')->apply([]), 'Checking our isa predicate does not evaluate an unblessed ref');
ok(!p_isa('EGUtils')->apply(undef), 'Checking our isa predicate does not evaluate an undef');
