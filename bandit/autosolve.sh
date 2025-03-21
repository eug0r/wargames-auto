#!/bin/bash

REMOTE_HOST="bandit.labs.overthewire.org"

####bandit 0 -> 1
REMOTE_USER="bandit0"
PASSWORD="bandit0"
REMOTE_COMMANDS="cat readme; exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
PASSWORD_EXTRACTED=$(echo "$OUTPUT" | grep "The password you are looking for is: "\
    | sed 's/.*The password you are looking for is: //;s/[[:space:]]*$//')

echo "b0 output: $PASSWORD_EXTRACTED"
####bandit 1 -> 2
REMOTE_USER="bandit1"
PASSWORD=$PASSWORD_EXTRACTED
REMOTE_COMMANDS="cat ./-; exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")

echo "b1 output: $OUTPUT"

####bandit 2 -> 3
REMOTE_USER="bandit2"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="cat spaces\ in\ this\ filename; exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")

echo "b2 output: $OUTPUT"

####bandit 3 -> 4
REMOTE_USER="bandit3"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="cd inhere;
    cat ...Hiding-From-You;
    exit"
OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b3 output: $OUTPUT"

####bandit 4 -> 5
REMOTE_USER="bandit4"
PASSWORD=$OUTPUT
#REMOTE_COMMANDS="cd inhere;
#    cat \$(file ./* | grep "ASCII" |sed 's/:.*//');
#    exit"
REMOTE_COMMANDS="cd inhere;
    file ./*\
    | grep "ASCII"\
    | awk -F':' '{print \$1}'\
    | xargs cat;
    exit"
#find the only ascii file.
#both of these work. remember to escape the $ and " in these commands so that they only get
#processed once they are passed to the remote. You don't want awk $1 or cat $() to be evaluated
#on local machine.
#awk -F':' cuts the string using :'s as delimiters. then print $1 grabs the first part.
OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b4 output: $OUTPUT"

####bandit 5 -> 6
REMOTE_USER="bandit5"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="cd inhere;
    file \$(ls -lRa -1 \"\$PWD/\"**/{*,.*} | grep 1033 | grep rw- | awk -F' ' '{print \$9}')\
    | grep ASCII\
    | awk -F':' '{print \$1}'\
    | xargs cat\
    | sed 's/[[:space:]]*$//';
    exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b5 output: $OUTPUT"

####bandit 6 -> 7
REMOTE_USER="bandit6"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="find / -user bandit7 -group bandit6 -size 33c 2>/dev/null \
    | xargs cat;
    exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b6 output: $OUTPUT"

####bandit 7 -> 8
REMOTE_USER="bandit7"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="cat data.txt\
    | grep millionth\
    | awk -F'millionth' '{print \$2}'\
    | sed 's/[[:space:]]\$*//';
    exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b7 output: $OUTPUT"

####bandit 8 -> 9
REMOTE_USER="bandit8"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="sort data.txt\
    | uniq -u;
    exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b8 output: $OUTPUT"

####bandit 9 -> 10
REMOTE_USER="bandit9"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="strings data.txt\
    | grep -Em1 \"^.{\$(strings data.txt | wc -L)}\$\"\
    | awk -F'= ' '{print \$2}';
    exit"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b9 output: $OUTPUT"

####bandit 10 -> 11
REMOTE_USER="bandit10"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="base64 -d data.txt\
    | awk -F'is ' '{print \$2}';"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b10 output: $OUTPUT"

####bandit 11 -> 12
REMOTE_USER="bandit11"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="tr '[a-zA-Z]' '[n-za-mN-ZA-M]' <data.txt\
    | awk -F'is ' '{print \$2}';"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b11 output: $OUTPUT"

####bandit 12 -> 13
REMOTE_USER="bandit12"
PASSWORD=$OUTPUT
REMOTE_COMMANDS="cd \$(mktemp -d);
    cp ~/data.txt .;
    xxd -r data.txt > data1.gz;
    gzip -d data1.gz;
    mv data1 data2.bz2;
    bzip2 -d data2.bz2;
    mv data2 data3.gz;
    gzip -d data3.gz;
    mv data3 data4.tar;
    tar -xf data4.tar data5.bin && mv data5.bin data5.tar;
    tar -xf data5.tar data6.bin && mv data6.bin data6.bz2;
    bzip2 -d data6.bz2;
    mv data6 data7.tar;
    tar -xf data7.tar data8.bin && mv data8.bin data8.gz;
    gzip -d data8.gz;
    cat data8\
    | awk -F'is ' '{print \$2}';"

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b12 output: $OUTPUT"

###bandit 13->14 and 14->15
REMOTE_USER="bandit13"
PASSWORD=$OUTPUT
INNER_REMOTE_COMMANDS="nc localhost 30000 < /etc/bandit_pass/bandit14 | grep -v Correct"
REMOTE_COMMANDS="ssh bandit14@bandit.labs.overthewire.org -p 2220 -i sshkey.private\
 -q -o StrictHostKeyChecking=no \"$INNER_REMOTE_COMMANDS\" "

OUTPUT=$(sshpass -p "$PASSWORD" ssh -q -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" -p 2220 "$REMOTE_COMMANDS")
echo "b14 output: $OUTPUT"

####bandit 15 -> 16
echo "submit the last flag to access bandit 15->16"