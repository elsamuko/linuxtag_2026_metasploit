#!/usr/bin/env bash

# exit on error
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/opt/metasploit-framework/bin":"/opt/metasploit-framework/embedded/bin":$PATH

function separator {
    printf "\n\e[1;33m%-$(tput cols)s\e[0m\n" "--$*" | tr " " "-"
}

separator "dump db"
(cd "$SCRIPT_DIR/../sql" && ./init_db.py)
sqlite3 "$SCRIPT_DIR/../sql/database.db" .dump

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

separator "run attack"
echo n | msfconsole \
    --no-database \
    --logger Stdout \
    --quiet \
    --resource run.r | tee result.txt

separator "check result"
if grep "STATUS: SUCCESS" < result.txt; then
    echo "Updated user to admin rights"
    sqlite3 "$SCRIPT_DIR/../sql/database.db" .dump
else
    echo "Failed to update user"
fi
