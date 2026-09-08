#!/usr/bin/env bash

# exit on error
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/metasploit-framework/bin":"/opt/metasploit-framework/embedded/bin":$PATH

function separator {
    printf "\n\e[1;33m%-$(tput cols)s\e[0m\n" "--$*" | tr " " "-"
}

separator "init db"
(cd "$SCRIPT_DIR/../sql" && ./init_db.py)

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

separator "run injection"
echo n | msfconsole \
    --no-database \
    --logger Stdout \
    --quiet \
    --resource run.r | tee result.txt

separator "result"
if grep "STATUS: SUCCESS" < result.txt; then
    echo "I am admin with $(grep "SESSION: .*" < result.txt)"
else
    echo "failed to login"
fi
