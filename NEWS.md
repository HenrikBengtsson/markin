# Version (development version)

 * ...
 

# Version 0.2.0 [2022-03-29]

## Significant Changes

 * Renamed tool and R package to **markin** (was **mdi**).  For
   backward compatibility, command `mdi` will still work as an alias
   for now.

 * Functions `mdi()` and `mdi_inject()` were renamed to `markin()` and
   `markin_inject()`.


# Version 0.1.0 [2022-03-23]

## Significant Changes

 * Now `mdi build` and `mdi inject` uses `.mdi/` for code blocks.

 * Now the code-block prefix no longer includes the file extension of
   the source file.  For example, `mdi build r.sh` will now use prefix
   `r` whereas in the past it was `r.sh`.
 

# Version 0.0.0-9000 [2020-08-27]

## New Features

 * Added `mdi()` and `mdi_inject()`.

 * Package created.
