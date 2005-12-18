#!/bin/bash

perl -pe '/^=head1 DESCRIPTION/ and print <STDIN>' lib/Apache2/SetOptions.pm >README.pod <<EOF
=head1 INSTALLATION

 perl Makefile.PL
 make
 make test
 make install

=head1 DEPENDENCIES

mod_perl2, Test::Deep

EOF

perldoc -tU README.pod >README
rm README.pod