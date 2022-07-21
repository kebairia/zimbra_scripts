#!/bin/env bash

#USERS="./users"

#for account in $(zmprov -l gaa)
#do
    #echo "$(zmprov ga $i cn sn displayName company title zimbraMailAlias zimbraMailForwardingAddress mobile pager telephoneNumber co l postalCode st street zimbraAccountStatus | sed "s/\# name/uid:/" | paste -sd',' | tr -d '[:space:]';)""pass:$(openssl rand -hex 8)"
#done

while read line; do
    echo "$(zmprov ga ${line} cn sn displayName company title zimbraMailAlias zimbraMailForwardingAddress mobile pager telephoneNumber co l postalCode st street zimbraAccountStatus \
        | sed "s/\# name/uid:/" \
        | paste -sd',' \
        | sed 's/:\s/:/g;s/\s,/,/g';)""pass:$(openssl rand -hex 8)"
done < users
