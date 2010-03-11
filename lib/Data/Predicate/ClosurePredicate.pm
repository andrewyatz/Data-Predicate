package Data::Predicate::ClosurePredicate;

use Mouse;

with 'Data::Predicate';

has 'closure' => ( isa => 'CodeRef', is => 'ro', required => 1 );
has 'description' => ( isa => 'Str', is => 'ro', default => 'unknown' );

sub apply {
  my ($self, $object) = @_;
  return $self->closure()->($object);
}

no Mouse;

1;
__END__
=pod

=head1 NAME

=head1 SYNOPSIS

  use Data::Predicate::ClosurePredicate;
  
  #A closure which evaluates if a given object is defined or not
  Data::Predicate::ClosurePredicate->new(closure => sub {
    my ($object) = @_;
    return (defined $object) ? 1 : 0;
  });

=head1 DESCRIPTION

A very simple abstraction from C<Data::Predicate> which encapsulates
the predicate logic in a closure given at construction time. This allows
us to build very specific tests whilst keeping our class count down. It
also allows for rapid prototyping of predicates & should speed become
an issue means the code can be easily migrated into a custom version.

=head1 ATTRIBUTES

=head2 closure - required

Takes in a CodeRef and assumes it will return true or false depending on
the outcome of evaluation of an object.

=head2 description

Allows you to tag a predicate with a description as when faced with
multiple predicates all of which are ClosurePredicate instances it can
be somewhat daunting.

Optional & defaults to unknown.

=head1 METHODS

=head2 apply()

Returns the value from an invocation of the attribute C<closure> with
the incoming object.

=head1 DEPENDENCIES

=over 8

=item Mouse

=back

=head1 AUTHOR

Andrew Yates

=head1 LICENCE

Copyright (C) 2010 "EBI"

This program was developed as part of work carried out by EMBL.

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut