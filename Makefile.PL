#!perl

use 5.008;
use ModPerl::MM ();
use Apache::TestMM qw(test clean);

# accept the configs from command line
Apache::TestMM::filter_args();
Apache::TestMM::generate_script('t/TEST');

ModPerl::MM::WriteMakefile(
  NAME              => 'Apache2::SetOptions',
  VERSION_FROM      => 'lib/Apache2/SetOptions.pm',
  PREREQ_PM         => { mod_perl2=>0, 'Test::Deep'=>0 },
  ABSTRACT_FROM     => 'lib/Apache2/SetOptions.pm',
  AUTHOR            => 'Torsten Foertsch <torsten.foertsch@gmx.net>',
  dist              => {
			PREOP => './mk_README.sh',
		       },
  clean             => {
			FILES=>"t/TEST",
		       },
);

sub MY::postamble {
  return <<'EOF';
README: lib/Apache2/SetOptions.pm mk_README.sh
	./mk_README.sh

rpm: dist
	rpmbuild -ba perl-Apache2-SetOptions.spec
EOF
}
