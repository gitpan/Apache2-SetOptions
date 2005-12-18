use strict;
#use warnings FATAL => 'all';

use Apache::Test qw(:withtestmore);
use Test::More;
use Test::Deep;
use Apache::TestUtil;
use Apache::TestRequest 'GET_BODY';
use Apache2::SetOptions;
use Apache2::Const -compile=>':options';

plan tests=>8;

my $hostport = Apache::TestRequest::hostport() || '';
t_debug("connecting to $hostport");

cmp_set( [split / /, GET_BODY( '/TestOptions/set_options?clear:indexes' )],
	 [qw{Includes}],
	 'clear:indexes' );

cmp_set( [split / /, GET_BODY( '/TestOptions/set_options?clear:indexes:includes' )],
	 [],
	 'clear:indexes:includes' );

cmp_set( [split / /, GET_BODY( '/TestOptions/set_options?set:execcgi' )],
	 [qw{ExecCGI Includes Indexes}],
	 'set:execcgi' );

cmp_set( [split / /, GET_BODY( '/TestOptions/set_options?set:execcgi:multiview' )],
	 [qw{ExecCGI Includes Indexes MultiView}],
	 'set:execcgi:multiview' );

cmp_set( [Apache2::RequestRec->allow_options_as_strings( Apache2::Const::OPT_ALL)],
	 [qw{ExecCGI Includes Indexes FollowSymLinks}],
	 'allow_options_as_strings(OPT_ALL)' );

cmp_set( [Apache2::RequestRec->allow_options_as_strings( Apache2::Const::OPT_NONE)],
	 [],
	 'allow_options_as_strings(OPT_NONE)' );

cmp_set( [Apache2::RequestRec->allow_options_as_strings( Apache2::Const::OPT_ALL |
							 Apache2::Const::OPT_SYM_OWNER )],
	 [qw{ExecCGI Includes Indexes FollowSymLinks SymLinksIfOwnerMatch}],
	 'allow_options_as_strings(OPT_ALL|OPT_SYM_OWNER)' );

cmp_deeply( [Apache2::RequestRec->allow_options_from_strings(qw{All SymLinksIfOwnerMatch Otto})],
	    [Apache2::Const::OPT_ALL | Apache2::Const::OPT_SYM_OWNER, ['Otto']],
	    'allow_options_from_strings' );

# Local Variables: #
# mode: cperl #
# End: #
