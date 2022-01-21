#!/usr/bin/env bash

# NOTE : Make sure you have a domain name pointinng to this IP address before running
NEW_USER="user"
USER_PASS="password"
RSA_KEY="~/.ssh/TEST"
RSA_PASS="password"
IPV4="000.000.000.000"
DOMAIN="hello.com"
EMAIL="user@mail.com"
NODE_V="17"
APP_V="0.0.1"
AUTHOR=""
SUBDOMAINS=("$DOMAIN www" "ftp" "api" "mail") # First entry must have $DOMAIN variable like this

# Create non root user
FILE1=$(<STEP1.sh)
echo $FILE1 | sed "s/\[USER\]/$NEW_USER/g" | sed "s/\[PASSWORD\]/$USER_PASS/g" > GEN_STEP1.sh
ssh -i $RSA_KEY "root@"$IPV4 'bash -s' -- < ./GEN_STEP1.sh ""
sleep 1
rm GEN_STEP1.sh

# Start server build protocol
FILE2=$(<STEP2.sh)
echo -n $FILE2 | sed "s/\[USER\]/$NEW_USER/g" | sed "s/\[PASSWORD\]/$USER_PASS/g" | sed "s/\[EMAIL\]/$EMAIL/g" > GEN_STEP2.sh

# Build server blocks
echo "# Initial server set up" > default
for (( I=1; I<=${#SUBDOMAINS[@]}; I++ ))
do
    BLOCK=$(<SERVER_BLOCK)
    D="${SUBDOMAINS[$I]}.$DOMAIN"
    PORT="900$I"
    echo $BLOCK | sed "s/\[DOMAIN\]/$D/g" | sed "s/\[PORT\]/$PORT/g" >> default
done
# Upload to default
scp -i $RSA_KEY default $NEW_USER"@"$IPV4":~/default"
rm default

# Add certbot stuffs to server build protocol
CERTBOT_STRING="sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN"
for (( I=2; I<=${#SUBDOMAINS[@]}; I++ ))
do
    CERTBOT_STRING+=" -d ${SUBDOMAINS[$I]}.$DOMAIN"
done
echo $CERTBOT_STRING >> GEN_STEP2.sh
echo "exit" >> GEN_STEP2.sh
# Run server build protocol
ssh -i $RSA_KEY $NEW_USER"@"$IPV4 'bash -s' -- < ./GEN_STEP2.sh ""
rm GEN_STEP2.sh

# Start Node build protocol
FILE3=$(<STEP3.sh)
# Build and upload js app stubs
APP=$(<APP_STUB)
echo $APP | sed "s/\[DOMAIN\]/$DOMAIN/g" | sed "s/\[VERSION\]/$APP_V/g" | sed "s/\[AUTHOR\]/$AUTHOR/g" | sed "s/\[PORT\]/9001/g" > "$DOMAIN.js"
APP_STRING="pm2 start $DOMAIN.js"
scp -i $RSA_KEY "$DOMAIN.js" $NEW_USER"@"$IPV4":~/$DOMAIN.js"
rm "$DOMAIN.js"
for (( I=2; I<=${#SUBDOMAINS[@]}; I++ ))
do
    APP=$(<APP_STUB)
    D="${SUBDOMAINS[$I]}"
    PORT="900$I"
    echo $APP | sed "s/\[DOMAIN\]/$D/g" | sed "s/\[VERSION\]/$APP_V/g" | sed "s/\[AUTHOR\]/$AUTHOR/g" | sed "s/\[PORT\]/$PORT/g" > "$D.js"
    APP_STRING+="\npm2 start $D.js"
    scp -i $RSA_KEY "$D.js" $NEW_USER"@"$IPV4":~/$D.js"
    rm "$D.js"
done
# Build and run protocol
echo $FILE3 | sed "s/\[NODE_V\]/$NODE_V/g" | sed "s/\[PASSWORD\]/$USER_PASS/g" | sed "s/\[APPS\]/$APP_STRING/g" | sed "s/\[USER\]/$NEW_USER/g" > GEN_STEP3.sh
ssh -i $RSA_KEY $NEW_USER"@"$IPV4 'bash -s' -- < ./GEN_STEP3.sh ""
rm GEN_STEP3.sh
