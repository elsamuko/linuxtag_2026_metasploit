#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# exit on error
set -e

export PATH="/opt/metasploit-framework/bin":"/opt/metasploit-framework/embedded/bin":$PATH

# check syntax
ruby -c ./modules/auxiliary/workshop/broken_access_control.rb

cat << EOF > run.r
loadpath modules
use auxiliary/workshop/broken_access_control
set RHOSTS 127.0.0.1
set RPORT 5005
show options
run
exit
EOF

echo n | msfconsole \
    --no-database \
    --logger Stdout \
    --quiet \
    --resource run.r | tee result.txt

if grep "STATUS: SUCCESS" < result.txt; then
    echo "Updated user to admin rights"
else
    echo "Failed to update user"
fi
