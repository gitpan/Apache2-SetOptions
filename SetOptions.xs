#include <mod_perl.h>

/* See server/core.c: set_options() */

typedef request_rec *Apache2__RequestRec;

MODULE = Apache2::SetOptions	PACKAGE = Apache2::SetOptions	PREFIX = mpxs_Apache2__RequestRec_

int
mpxs_Apache2__RequestRec_set_allow_options(r,options)
	Apache2::RequestRec r
	int options
PROTOTYPE: $$
CODE:
	{
	  core_dir_config *d;
	  d=(core_dir_config *)ap_get_module_config(r->per_dir_config,
						    &core_module);
	  d->opts |= options;

	  RETVAL=1;
	}
OUTPUT:
	RETVAL

int
mpxs_Apache2__RequestRec_clear_allow_options(r,options)
	Apache2::RequestRec r
	int options
PROTOTYPE: $$
CODE:
	{
	  core_dir_config *d;
	  d=(core_dir_config *)ap_get_module_config(r->per_dir_config,
						    &core_module);
	  d->opts &= ~options;

	  RETVAL=1;
	}
OUTPUT:
	RETVAL

## Local Variables: ##
## mode: c ##
## End: ##
