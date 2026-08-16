#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# exit on error
set -e

export PATH="/opt/metasploit-framework/bin":"/opt/metasploit-framework/embedded/bin":$PATH

# check syntax
ruby -c ./modules/auxiliary/workshop/sql_inject_login.rb

cat << EOF > run.r
loadpath modules
use auxiliary/workshop/sql_inject_login
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
    echo "I am admin with $(grep "SESSION: .*" < result.txt)"
else
    echo "failed to login"
fi
