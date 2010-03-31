package Data::Predicate;

use Mouse::Role;

our $VERSION = '1.0.1';

requires 'apply';

sub filter {
  my ($self, $values) = @_;
  return [ grep { $self->apply($_) } @{$values}];
}

sub filter_transform {
  my ($self, $values, $transformer) = @_;
  my @transformed;
  foreach my $value (@{$values}) {
    if($self->apply($value)) {
      push(@transformed, $transformer->($value));
    }
  }
  return \@transformed;
}

sub all_true {
  my ($self, $objects) = @_;
  my $count = $self->_count_truth($objects);
  return (scalar(@{$objects}) == $count) ? 1 : 0;
}

sub all_false {
  my ($self, $objects) = @_;
  my $count = $self->_count_truth($objects);
  return ($count == 0) ? 1 : 0;
}

sub _count_truth {
  my ($self, $objects) = @_;
  my $count = 0;
  foreach my $obj (@{$objects}) {
    $count++ if $self->apply($obj);
  }
  return $count;
}

no Mouse::Role;

1;
__END__
=pod

=head1 NAME

Data::Predicate

=head1 SYNOPSIS

  my $predicate = get_a_predicate(); #Say this returns true if an object is defined & a number
  $predicate->apply(1); #returns true
  $predicate->apply('a'); #returns false
  $predicate->apply(undef); #returns false
  
  my @data = (1, 'a', undef, 2, 3);
  $predicate->filter(\@data); #returns [1,2,3]
  $predicate->filter_transform(\@data, sub { $_*2 }); #returns [2,4,6]
  
  $predicate->all_true([1,2,3]); #Returns true
  $predicate->all_false([qw(a b c)]); #Returns true 

=head1 DESCRIPTION

This idea of predicates is taken from 
L<<a href='http://commons.apache.org/collections/'>Apache Commons collections</a>>
and L<<a href='http://code.google.com/p/google-collections/'>google-collections</a>>.

Predicates are a way of composing logic so it eventually reports a true/false
for a given value. The criteria for coming up with this reponse could be
quite complex but always the answer has to be boolean. The predicates
can also do filtering of an array reference of items and do transformations
on those items when a predicate returns true.

Predicates also allow for more complex and/or statements to be built. For
example:

  use Data::Predicate::Predicates qw(:all);
  my $or_predicate = p_or(map { p_string_equals($_) } qw(a b c d e f) );
  my $and_predicate = p_and( p_defined(), $or_predicate );
  
  my $truth = $and_predicate->apply('a');
  $truth = $and_predicate->apply('d');
  $truth = $and_predicate->apply('f');
  
This is functionally equivalent to:

  my ($v) = @_;
  if(defined $v && ( $v eq 'a' || $v eq 'b' || $v eq 'c' || $v eq 'd' || $v eq 'e' || $v eq 'f')) {
    
  }

This or code will also begin to shortcut operations in the same way the above
if statement would have done.

However one word of warning is that you should not use predicates for matters
where simple logic will suffice. Do not use it when doing simple if tests
or simple list grepping. Predicates are not a Perlism and will make your
code harder to read to the un-initiated.

=head1 WHAT DO YOU WANT TO USE

9 times out of 10 you want L<Data::Predicate::Predicates> which provides
a set of useful pre-built predicates. If this does not have a predicate to
suit your mood then apply this role to a class of your own and start
writing.

=head1 MOUSE?

Mouse is my post-modern meta-object protocol aware object builder of choice. 
Moose is better but I program in Mouse. If you want it in Moose then fork
& produce a Moose version; it should be functionally equivalent.

=head1 METHODS

=head2 apply()

The core method; give it a reference and the apply method will return true
or false depending on the predicate contents. This is just a Mouse::Role
and a required method for anything which uses this Role.

=head2 filter()

  p_defined()->filter([undef,1,2]); #Will return [1,2]

More complex version of the apply which runs over a given array reference 
of items. The synopsis has a very good example of what it can do. 

=head2 filter_transform()

  p_defined()->filter_transform([undef,1,2], sub { $_*2 }); #Will return [2,4]

An evolution of the L<filter> code which when the predicate evaluates to
true this code will then trigger a transformaiton process of the value
and return a new list filled with these values.

=head2 all_true()

Returns true if all values in the given array reference were true. A quick
way of deciding to accept a set of values without writing a loop. 

=head2 all_false()

Returns false if all values in the given array reference were false. A quick
way of deciding to reject a set of values without writing a loop. 

=head1 AUTHOR

Andrew Yates

=head1 VERSION

1.0

=head1 LICENCE

Copyright (C) 2010 "EBI"

This program was developed as part of work carried out by EMBL.

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut