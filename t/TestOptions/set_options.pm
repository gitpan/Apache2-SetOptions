package TestOptions::set_options;

use strict;
use warnings FATAL => 'all';
no warnings 'uninitialized';

use Apache2::RequestRec ();
use Apache2::RequestUtil ();
use Apache2::RequestIO ();
use Apache2::Access ();
use Apache2::SetOptions ();

use Apache2::Const -compile => qw(OK DECLINED :options);

sub o2s {
  my $o=shift;
  my $rc='';

  foreach (
	   [Apache2::Const::OPT_EXECCGI, "ExecCGI"],
	   [Apache2::Const::OPT_INCLUDES, "Includes"],
	   [Apache2::Const::OPT_INCNOEXEC, "IncludesNOEXEC"],
	   [Apache2::Const::OPT_INDEXES, "Indexes"],
	   [Apache2::Const::OPT_MULTI, "MultiView"],
	   [Apache2::Const::OPT_SYM_LINKS, "FollowSymLinks"],
	   [Apache2::Const::OPT_SYM_OWNER, "SymLinksIfOwnerMatch"],
	  ) {
    $rc.=' '.$_->[1] if( $o & $_->[0] );
  }

  $rc=~s/^\s*//;
  return $rc;
}

my %options=(
	     "execcgi" => Apache2::Const::OPT_EXECCGI,
	     "includes" => Apache2::Const::OPT_INCLUDES,
	     "includesnoexec" => Apache2::Const::OPT_INCNOEXEC,
	     "indexes" => Apache2::Const::OPT_INDEXES,
	     "multiview" => Apache2::Const::OPT_MULTI,
	     "followsymlinks" => Apache2::Const::OPT_SYM_LINKS,
	     "symlinksifownermatch" => Apache2::Const::OPT_SYM_OWNER,
	    );

sub s2o {
  my $rc=0;

  foreach (@_) {
    if( exists $options{lc $_} ) {
      $rc|=$options{lc $_};
    } else {
      warn "No such Option: $_\n";
    }
  }

  return $rc;
}

sub init {
  my $r = shift;

  my ($what, @opts)=split /:/, $r->args;

  if( $what eq 'clear' ) {
    $r->clear_allow_options(s2o(@opts));
  } else {
    $r->set_allow_options(s2o(@opts));
  }

  return Apache2::Const::DECLINED;
}

sub handler {
  my $r = shift;

  $r->content_type('text/plain');

  $r->print(o2s($r->allow_options));

  Apache2::Const::OK;
}

1;
