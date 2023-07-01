#!/bin/bash
set -eu

# lint cdr
shellcheck cdr
# lint cdr --wrapper sh output
shellcheck <(echo '#!/bin/sh'; ./cdr --wrapper sh)
# lint cdr --wrapper bash output
# NOTE:
# SC2016: Allow expand notation in fixed string to allow expansion in compgen arguments
# SC2034: Allow unused variables to allow variables used in compgen arguments
# SC2207: Allow array=( $() ) to allow copy values from compgen output to COMPREPLY
shellcheck -e SC2016,SC2034,SC2207 <(echo '#!/bin/bash'; ./cdr --wrapper bash)
