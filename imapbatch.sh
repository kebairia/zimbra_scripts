#!/bin/bash

echo "Imapsync start ...."

USER=$1

echo -e "User ####################  ${USER} ##################### To sync\n"

SOURCE_HOST="172.16.100.30"
DEST_HOST="172.16.100.32"


echo -e "User ####################  ${line} ##################### To sync\n"
#LOGIN1="${USER}*zmaster"
LOGIN1="${USER}"
LOGIN2="${USER}"

/usr/bin/imapsync --tmpdir /home/work/tmp --logdir /home/work/log --nosyncacls --syncinternaldates --subscribe \
  --addheader \
    --buffersize 8192000 \
    --nosyncacls --subscribe --syncinternaldates \
    --exclude '(?i)\b(Junk|Spam|Trash)\b' \
    --regexflag 's/\\\\(?!Answered|Flagged|Deleted|Seen|Recent|Draft)[^\s]*\s*//ig' \
    --regexflag 'tr,:"/,_,' \
    --regextrans2 's,:,-,g' \
    --regextrans2 's,\*,,g' \
    --regextrans2 's,\",'\'',g' \
    --regextrans2 's,\s+(?=/|$),,g' \
    --regextrans2 's,^(Briefcase|Calendar|Contacts|Emailed Contacts|Notebook|Tasks)(?=/|$), $1 Folder,ig' \
    --host1 ${SOURCE_HOST} --user1  ${LOGIN1} --authuser1 admin --passfile1 /root/mailsourcepass.txt --authmech2 PLAIN --port1 143 --timeout1 300 \
    --host2 ${DEST_HOST}   --user2  ${LOGIN2} --authuser2 admin --passfile2 /root/maildestpass.txt   --authmech2 PLAIN --port2 143 --timeout2 300 \
    --regextrans2 's,\",-,g' \
    --regextrans2 's,&AAo-|&AA0ACg-|&AA0ACgANAAo-(?=/|$),,g'

#time parallel  --joblog /root/parallel.log -j numjobs.txt -a allzimusers-12122018.txt ./delta_exec_imapsync.sh {}
