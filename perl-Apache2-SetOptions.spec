Name:         perl-Apache2-SetOptions
License:      Artistic License
Group:        Development/Libraries/Perl
Provides:     p_Apache2_SetOptions
Obsoletes:    p_Apache2_SetOptions
Requires:     perl = %{perl_version}
Autoreqprov:  on
Summary:      Apache2::SetOptions
Version:      0.01
Release:      1
Source:       Apache2-SetOptions-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}-build

%description
Apache2::SetOptions extent Apache2::RequestRec to modify Apache's Options
settings.

Authors:
--------
    Torsten Foertsch <torsten.foertsch@gmx.net>

%prep
%setup -n Apache2-SetOptions-%{version}
# ---------------------------------------------------------------------------

%build
perl Makefile.PL
make && make test
# ---------------------------------------------------------------------------

%install
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;
make DESTDIR=$RPM_BUILD_ROOT install_vendor
%{_gzipbin} -9 $RPM_BUILD_ROOT%{_mandir}/man3/Apache2::SetOptions.3pm || true
%perl_process_packlist

%clean
[ "$RPM_BUILD_ROOT" != "/" ] && [ -d $RPM_BUILD_ROOT ] && rm -rf $RPM_BUILD_ROOT;

%files
%defattr(-, root, root)
%{perl_vendorarch}/Apache2
%{perl_vendorarch}/auto/Apache2
%doc %{_mandir}/man3/Apache2::SetOptions.3pm.gz
/var/adm/perl-modules/perl-Apache2-SetOptions
%doc MANIFEST README
