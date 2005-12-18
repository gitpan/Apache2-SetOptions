package Apache2::SetOptions;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.01';

use Apache2::XSLoader ();
Apache2::XSLoader::load __PACKAGE__;

use Apache2::RequestRec ();
use Apache2::Access ();
use Apache2::Const -compile=>':options';

BEGIN {push @Apache2::RequestRec::ISA, __PACKAGE__;}

sub allow_options_as_strings {
  my $r=shift;
  my $opts;
  my @rc;

  if( @_ ) {
    $opts=shift;
  } else {
    $opts=$r->allow_options;
  }

  foreach my $o (
		 [Apache2::Const::OPT_EXECCGI, "ExecCGI"],
		 [Apache2::Const::OPT_INCLUDES, "Includes"],
		 [Apache2::Const::OPT_INCNOEXEC, "IncludesNOEXEC"],
		 [Apache2::Const::OPT_INDEXES, "Indexes"],
		 [Apache2::Const::OPT_MULTI, "MultiView"],
		 [Apache2::Const::OPT_SYM_LINKS, "FollowSymLinks"],
		 [Apache2::Const::OPT_SYM_OWNER, "SymLinksIfOwnerMatch"],
		) {
    push @rc, $o->[1] if( $opts & $o->[0] );
  }

  return @rc;
}

my %options=(
	     "execcgi" => Apache2::Const::OPT_EXECCGI,
	     "includes" => Apache2::Const::OPT_INCLUDES,
	     "includesnoexec" => Apache2::Const::OPT_INCNOEXEC,
	     "indexes" => Apache2::Const::OPT_INDEXES,
	     "multiview" => Apache2::Const::OPT_MULTI,
	     "followsymlinks" => Apache2::Const::OPT_SYM_LINKS,
	     "symlinksifownermatch" => Apache2::Const::OPT_SYM_OWNER,
	     "all" => Apache2::Const::OPT_ALL,
	     "none" => Apache2::Const::OPT_NONE,
	    );

sub allow_options_from_strings {
  my $r=shift;
  my $rc=0;
  my @warnings;

  foreach my $o (@_) {
    my $x=lc($o);
    if( exists $options{$x} ) {
      $rc|=$options{lc $x};
    } else {
      push @warnings, $o;
    }
  }

  return $rc, \@warnings;
}

1;
__END__
=head1 NAME

Apache2::SetOptions - Set Apache Options from Perl

=head1 SYNOPSIS

  use Apache2::RequestRec;
  use Apache2::SetOptions;
  use Apache2::Const -compile=>':options';

  $r->set_allow_options( Apache2::Const::OPT_EXECCGI |
                         Apache2::Const::OPT_INDEXES );

  $r->clear_allow_options( Apache2::Const::OPT_EXECCGI |
                           Apache2::Const::OPT_INDEXES );

  @list=$r->allow_options_as_strings( Apache2::Const::OPT_EXECCGI |
                                      Apache2::Const::OPT_INDEXES );

  ($opts, $err)=$r->allow_options_from_strings( qw{All
                                                   SymLinksIfOwnerMatch
                                                   MultiView} );

=head1 DESCRIPTION

This module adds a few methods to C<Apache2::RequestRec> class to
work with Apache's C<Options>.

=head2 METHODS

=over 4

=item B<< $r->set_allow_options( $opts ) >>

=item B<< $r->clear_allow_options( $opts ) >>

These 2 methods set or clear C<Options> in the current
C<< $r->per_dir_config >>. Remember that C<< $r->per_dir_config >> is
reset after the Uri Translation Phase. Thus, these methods are not
useful in an C<PerlPostReadRequestHandler> or a C<PerlTransHandler>.

When called from a C<PerlMapToStorageHandler> options set this way
may be overridden in later phases since after this phase C<< <Directory> >>,
C<< <Files> >> and C<< <Location> >> sections are merged.

Options set the Header Parser Phase or later are valid until the end
of the request cycle.

=item B<< @strings=$r->allow_options_as_strings( $opts ) >>

=item B<< @strings=Apache2::SetOptions->allow_options_as_strings( $opts ) >>

convert an C<Options> value into human readable strings.

=item B<< ($opts, $err)=$r->allow_options_from_strings( @words ) >>

=item B<< ($opts, $err)=Apache2::SetOptions->allow_options_from_strings( @words ) >>

convert strings into an C<Options> value. The 2nd return value is an
ARRAY reference containing words that aren't known options.

=back

=head2 EXPORT

nothing

=head1 SEE ALSO

mod_perl2

=head1 AUTHOR

Torsten Foertsch, E<lt>torsten.foertsch@gmx.netE<gt>

=head1 SPONSORING

Sincere thanks to Arvato Direct Services (http://www.arvato.com/) for
sponsoring this module.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Torsten Foertsch

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
