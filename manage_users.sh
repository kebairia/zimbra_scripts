#!/bin/env bash
#CONSTANTS
DATA=./users_db_test.csv
NUM_USERS=$(wc -l $DATA | awk '{print $1}')
# FUNCTIONS
# generate users info {{{1
echo_error(){
    echo -e '\e[5;31mERR:\e[0m' $1
}
echo_info(){
    echo -e "\e[0;33mINFO:\e[0m" $1
}
generate_users_info(){
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃ GENERATING USERS INFO ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━┛"

}
#}}}
#create users {{{1
create_users(){
    #
    #Function to create users listed in ${DATA} file and force users to change their password at first login
    #
    echo "┏━━━━━━━━━━━━━━━━━┓"
    echo "┃ CREATING USERS  ┃"
    echo "┗━━━━━━━━━━━━━━━━━┛"

    index=1
    while read line; do

        # Mandatory
        uid=$(echo $line | awk -F ',' '{print $1}') && uid=${uid#*:} && [ -z $uid ] \
            && echo_error "UID is missing for account number ${index}, this field is mandatory...exiting"  && exit 1
        pass=$(echo $line | awk -F ',' '{print $6}') && pass=${pass#*:} && [ -z $pass ] \
            && echo_error "password is missing for ${uid}, this field is mandatory...exiting"  && exit 2
        # Optional 
        id_cn=''
        cn=$(echo $line | awk -F ',' '{print $2}') && cn=${cn#*:} && [ ! -z $cn ] && id_cn='cn'
        id_displayName=''
        displayName=$(echo $line | awk -F ',' '{print $3}') && displayName=${displayName#*:} \
            && [ ! -z $displayName ] && id_displayName='displayName'
        id_sn=''
        sn=$(echo $line | awk -F ',' '{print $4}') && sn=${sn#*:} && [ ! -z $sn ] && id_sn='sn'
        id_zas=''
        zas=$(echo $line | awk -F ',' '{print $5}') && zas=${zas#*:} && [ ! -z $zas ] && id_zas='zimbraAccountStatus'

        echo -n "[${index}/${NUM_USERS}]:Creating $uid UID: " \
            && zmprov ca $uid $pass $id_cn "$cn" $id_displayName "$displayName" $id_sn "$sn" $id_zas $zas \
            && zmprov ma ${uid} zimbraPasswordMustChange TRUE

            index=$((index+1))
    done < $DATA | tee script.log


}
#}}}
# dump users info {{{1
dump_users_info(){
    echo "┏━━━━━━━━━━━━━━━━━┓"
    echo "┃ DUMP USERS INFO ┃"
    echo "┗━━━━━━━━━━━━━━━━━┛"
    cat $DATA | awk -F, '{print $1, $NF}' | sed 's/uid/ACCOUNT/;s/pass/PASS/' > users_info.txt

}
#}}}
# usage {{{1
usage (){
cat << EOF
create-users [OPTION]

OPTION
    --setup-users   create blank users account with random password, (users are forced to change their passwords on first login)
    --users-info    dump users information (uid and password) in a file
    --dump-info     dump users information (uid and password) in a file
    --help          print this help
EOF
}
#}}}

while [ ! -z $1 ]; do
    case $1 in
        -i | --users-info ) generate_users_info ;;
        -s | --setup-users ) create_users ;;
        -d | --dump-info ) ;;
        * ) usage ;;

    esac
    shift
done
#ca:a.bourachedi@crstdla.dz,cn:AbdelghaniBourachedi,displayName:AbdelghaniBourachedi,sn:Bourachedi,zimbraAccountStatus:active,pass:f7c3a7972ce37fc8
# zmprov ca user@domain cn llllll 