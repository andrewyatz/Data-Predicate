{
  package One; 
  use Mouse;
  has 'val' => ( isa => 'Str', is => 'ro', default => 'hello' );
  no Mouse;
  package Two;
  use Mouse;
  extends 'One';
  no Mouse;
  1;
  package Tmp;
  sub new { return bless([], 'Tmp');}
  sub val { my ($self) = @_; return $self->[0]; }
}

package main;

use strict;
use warnings;
use Test::More tests => 8;

use Data::Predicate::Predicates qw(:all);

my $p = p_isa('One');

my $str = 'str';
ok(! $p->apply(undef), 'Cannot call isa() on an undef value');
ok(! $p->apply($str), 'Cannot call isa() on a Scalar');
ok(! $p->apply(\$str), 'Cannot call isa() on a ScalarRef');
ok(! $p->apply([]), 'Cannot call isa() on a ArrayRef');
ok(! $p->apply({}), 'Cannot call isa() on a HashRef');

ok($p->apply(One->new()), 'Object One isa One');
ok($p->apply(Two->new()), 'Object Two isa One');
ok(!$p->apply(Tmp->new()), 'Object Tmp is blessed but is not a One');