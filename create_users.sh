#!/bin/env bash
#CONSTANTS
DATA=./users_db.csv
# FUNCTIONS
# generate users info {{{1
generate_users_info(){
    echo "+-----------------------+"
    echo "| GENERATING USERS INFO |"
    echo "+-----------------------+"

}
#}}}
#create users {{{1
create_users(){

    echo "+----------------+"
    echo "| CREATING USERS |"
    echo "+----------------+"

    while read line; do

        uid=$(echo $line | awk -F ',' '{print $1}') && uid=${uid#*:} && [ ! -z $uid ] && id_uid='ca'
        pass=$(echo $line | awk -F ',' '{print $6}') && pass=${pass#*:} && [ ! -z $pass ] && id_pass='pass'
        id_cn=''
        cn=$(echo $line | awk -F ',' '{print $2}') && cn=${cn#*:} && [ ! -z $cn ] && id_cn='cn'
        id_displayName=''
        displayName=$(echo $line | awk -F ',' '{print $3}') && displayName=${displayName#*:} \
            && [ ! -z $displayName ] && id_displayName='displayName'
        id_sn=''
        sn=$(echo $line | awk -F ',' '{print $4}') && sn=${sn#*:} && [ ! -z $sn ] && id_sn='sn'
        id_zas=''
        zas=$(echo $line | awk -F ',' '{print $5}') && zas=${zas#*:} && [ ! -z $zas ] && id_zas='zimbraAccountStatus'

        zmprov $id_uid $uid $pass $id_cn "$cn" $id_displayName "$displayName" $id_sn "$sn" $id_zas $zas
    done < $DATA


}
#}}}
# dump users info {{{1
dump_users_info(){
    cat $DATA | awk -F"," '{print $1, $NF}' | sed 's/uid/ACCOUNT/;s/pass/PASS/' > users_info.txt

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
case $1 in
    --users-info ) generate_users_info ;;
    --setup-users ) create_users ;;
    --dump-info ) ;;
    * ) usage ;;
esac
#ca:a.bourachedi@crstdla.dz,cn:AbdelghaniBourachedi,displayName:AbdelghaniBourachedi,sn:Bourachedi,zimbraAccountStatus:active,pass:f7c3a7972ce37fc8
# zmprov ca user@domain cn llllll 
