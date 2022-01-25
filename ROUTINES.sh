#!/usr/local/bin/bash
####################################################################################################################
###                                                                                                              ###
###                    SERVER OPS AUTOMATION WITH PROFILES                                                       ###
###                                                                                                              ###
###                    Author : Rebel Rae Brown                                                                  ###
###                    Email : Rebel@TheDeviantRebel.com                                                         ###
###                    Current Version : 1.0.2                                                                   ###
###                    Release Date : Tue Jan 25 08:42:57 PST 2022                                               ###
###                                                                                                              ###
###                    Support : PayPal.me/RebelRae                                                              ###
###                                                                                                              ###
####################################################################################################################

# ==================== | Colors | ==================== #
BASE='\033[0m'
BLACK='\033[0;30m';     DGREY='\033[1;30m'
RED='\033[0;31m';       LRED='\033[1;31m'
GREEN='\033[0;32m';     LGREEN='\033[1;32m'
BROWN='\033[0;33m';     YELLOW='\033[1;33m'
BLUE='\033[0;34m';      LBLUE='\033[1;34m'
PURPLE='\033[0;35m';    LPURPLE='\033[1;35m'
CYAN='\033[0;36m';      LCYAN='\033[1;36m'
WHITE='\033[1;37m';     LGREY='\033[0;37m'
declare -A COLORS
COLORS=([BASE]='\033[0m'
[BLACK]='\033[0;30m' [DGREY]='\033[1;30m'
[RED]='\033[0;31m' [LRED]='\033[1;31m'
[GREEN]='\033[0;32m' [LGREEN]='\033[1;32m'
[BROWN]='\033[0;33m' [YELLOW]='\033[1;33m'
[BLUE]='\033[0;34m' [LBLUE]='\033[1;34m'
[PURPLE]='\033[0;35m' [LPURPLE]='\033[1;35m'
[CYAN]='\033[0;36m' [LCYAN]='\033[1;36m'
[WHITE]='\033[1;37m' [LGREY]='\033[0;37m')
# ==================== | Credit Variables | ==================== #
AUTHOR="Rebel Rae Brown"
VERSION="1.0.2"
RELEASE_DATE="Tue Jan 25 08:42:57 PST 2022"
# ==================== | User Variables | ==================== #
declare -A SETTINGS
SETTINGS=([IPV4]="" [DOMAIN]="" [USER_PASS]="" [NODE_V]="" [RSA_PASS]="" [APP_V]="" [RSA_KEY]="" [EMAIL]="" [NEW_USER]="")
SUBDOMAINS=("www" "ftp" "api" "mail" "dev" "media" "websockets" "resume")
USER=""
PASSWORD=""
# ==================== | App Variables | ==================== #
DATE=`date`
DIMENSIONS=(95 1)
L_MARGIN=8
CORNER_CHAR="*"
CORNER_COLOR=${COLORS[LPURPLE]}
TB_CHAR="-"
TB_COLOR=${COLORS[LCYAN]}
LR_CHAR="|"
LR_COLOR=${COLORS[LCYAN]}
MENU_COLOR=${COLORS[LGREY]}
# ==================== | Menus | ==================== #
MAIN=("NGINX & NODE.JS SERVER BUILDER" "Version : 1.0.2" "Date : $DATE" "" "[H]elp Menu" "[S]ettings Wizard" "[R]un Server Scripts" "[C]credits" "" "[Q]uit")
HELP=("HELP" "Here is a sample help menu" "" "[M]ain Menu" "[Q]uit")
SETTINGS_WIZARD=("SETTINGS WIZARD" "Let's edit your settings!" "" "[U]pdate Settings" "[A]dd Setting" "[D]elete Setting" "[R]eset All Settings" "[M]ain Menu" "" "[Q]uit")
NEW_SERVER=( "NEW SERVER" "Server operations" "" "[U]ser (Adds new user to server with SSH login using your RSA key)" "[D]elete Current User" "[M]ain Menu" "" "[Q]uit")
CREDITS=("NGINX & NODE.JS SERVER BUILDER" "Author : Rebel Rae Brown" "Version : 1.0.2" "Release Date : Tue Jan 25 08:42:57 PST 2022" "" "[M]ain Menu" "[Q]uit")
CURRENT_MENU=()
# ==================== | Menu Routines | ==================== #
assignMenu(){
    temp="$1[@]"
    arr=("${!temp}")
    CURRENT_MENU=()
    for ((I = 1; I <= ${#arr[@]}; I++))
    do
        CURRENT_MENU[$I-1]=${arr[$I]}
    done
    clear
    # Measure
    MENU_HEIGHT=$(( ${#CURRENT_MENU[@]}+2 ))
    if (( $MENU_HEIGHT < ${DIMENSIONS[1]} ))
    then
        MENU_HEIGHT=${DIMENSIONS[1]}
    fi
    TITLE="| ${arr[0]} |"
    MENU_MIDDLE=$(( ${DIMENSIONS[0]}/2 ))
    TITLE_MIDDLE=$(( ${#TITLE}/2 ))
    TITLE_OFFSET=$(( $MENU_MIDDLE-$TITLE_MIDDLE ))
    MENU_TB="${CORNER_COLOR}$CORNER_CHAR${TB_COLOR}"
    MENU_BOTTOM="${CORNER_COLOR}$CORNER_CHAR${TB_COLOR}"
    for (( I=0; I<${DIMENSIONS[0]}; I++ ))
    do
        if (( $I > $TITLE_OFFSET-1 )) && (( $I < $TITLE_OFFSET + ${#TITLE} ))
        then
            MENU_TB+="${LGREEN}${TITLE:(( $I-$TITLE_OFFSET )):1}${TB_COLOR}"
        else
            MENU_TB+=$TB_CHAR
        fi
        MENU_BOTTOM+=$TB_CHAR
    done
    MENU_TB+="${CORNER_COLOR}$CORNER_CHAR${LR_COLOR}"
    MENU_BOTTOM+="${CORNER_COLOR}$CORNER_CHAR${LR_COLOR}"
    echo -e "$MENU_TB"
    for (( I=0; I<$MENU_HEIGHT; I++ ))
    do
        # 
        LINE_STR=""
        LEN=0
        if (( $(($I-1)) < ${#CURRENT_MENU[@]} )) && (( $(($I-1)) >= 0 ))
        then
            LINE_STR="${CURRENT_MENU[$(($I-1))]}"
            LEN=${#LINE_STR}
        fi
        # 
        MENU_LR="${LR_COLOR}$LR_CHAR${MENU_COLOR}"
        for (( J=0; J<${DIMENSIONS[0]}; J++ ))
        do
            if (( $J >= $L_MARGIN )) && (( $J < $LEN+$L_MARGIN ))
            then
                MENU_LR+=${LINE_STR[$(($J-$L_MARGIN))]}
            else
                MENU_LR+=" "
            fi
        done
        MENU_LR+="${LR_COLOR}$LR_CHAR"
        echo -e "$MENU_LR"
    done
    echo -e "$MENU_BOTTOM${COLORS[BASE]}"
    return
}
loading(){
    I_LOAD=0
    while true
    do
        if (( $I_LOAD == ${DIMENSIONS[0]}+1 ))
        then
            I_LOAD=0
        fi
        LOAD_STRING=""
        for (( J=0; J<$I_LOAD; J++ ))
        do
            LOAD_STRING+="#"
        done
        echo -n -e "\r\e[K$LOAD_STRING"
        (( I_LOAD++ ))
        sleep .1
        if [ -e page ]
        then
            rm page
            break
        fi
    done
    return
}
# ==================== | Settings Routines | ==================== #
loadSettings(){
    FILE_STR=$(openssl enc -aes-256-cbc -d -in users/$USER -k $PASSWORD)
    OLD_IFS=$IFS
    IFS=';'
    read -r -a FILE_ARR <<< $FILE_STR
    IFS=$OLD_IFS
    SETTINGS=()
    for KEY in "${FILE_ARR[@]}"
    do
        SET=$(echo "$KEY" | grep -o  '^.*=' |  tr -d '=')
        VAL=$(echo "$KEY" | grep -o  '=.*$' |  sed "s/\"//g")
        VAL="${VAL:1}"
        SETTINGS[$SET]=$VAL
    done
    return
}
saveSettings(){
    OUT_STRING=""
    for KEY in "${!SETTINGS[@]}"
    do
        OUT_STRING+="${KEY}=${SETTINGS[$KEY]};"
    done
    echo -n -E $OUT_STRING | openssl enc -aes-256-cbc -salt -k $PASSWORD > users/$USER
    return
}
deleteSetting(){
    echo $1
    declare -A TEMP
    TEMP=()
    for KEY in "${!SETTINGS[@]}"
    do
        if [[ ! $1 = $KEY ]]
        then
            TEMP[$KEY]=${SETTINGS[$KEY]}
        fi
    done
    SETTINGS=()
    for KEY in "${!TEMP[@]}"
    do
        SETTINGS[$KEY]=${TEMP[$KEY]}
    done
    saveSettings
    VAL_MENU=("SETTINGS WIZARD" "Entry $1 deleted. Your new settings are:" "")
    I=${#VAL_MENU[@]}
    for K in "${!SETTINGS[@]}"
    do
        VAL_MENU[$I]="-> $K"
        ((I++))
    done
    VAL_MENU[$I]=""
    ((I++))
    VAL_MENU[$I]="Press any key to continue"
    assignMenu VAL_MENU
    read -s -n1
    return
}
clearSettings(){
    SETTINGS=([IPV4]="" [DOMAIN]="" [USER_PASS]="" [NODE_V]="" [RSA_PASS]="" [APP_V]="" [RSA_KEY]="" [EMAIL]="" [NEW_USER]="")
    saveSettings
    return
}
updateSettings(){
    loadSettings
    for key in "${!SETTINGS[@]}"
    do
        SETTINGS_WIZARD=("SETTINGS WIZARD"
            "Enter new values below"
            "Press return key to accept current value" ""
            "${key}: ${SETTINGS[$key]}"
        )
        assignMenu SETTINGS_WIZARD
        SETTINGS[$key]=${SETTINGS[$key]}
        while read -r REPLY
        do
            if (( ${#REPLY} > 0 ))
            then
                SETTINGS[$key]=$REPLY
            fi
            break
        done
    done
    saveSettings
    SETTINGS_WIZARD=("SETTINGS WIZARD" "All done!" "Press any key to continue")
    assignMenu SETTINGS_WIZARD
    SETTINGS_WIZARD=("SETTINGS WIZARD" "Let's edit your settings!" "" "[U]pdate Settings" "[A]dd Setting" "[D]elete Setting" "[R]eset All Settings" "[M]ain Menu" "" "[Q]uit")
    read -s
    echo false > page
    return
}
# ==================== | User Routines | ==================== #
testUser(){
    A=$(openssl enc -aes-256-cbc -d -in users/$USER -k $PASSWORD 2>/tmp/err)
    if [[ -e /tmp/err ]]
        then
            rm /tmp/err
    fi
    if [[ $A == *"=;"* ]] || [[ $A == *"="*";"* ]]
    then
        echo true
    else
        echo false
    fi
    return
}
newUser(){
    USER_MENU=("NEW USER" "This is the first time you've used Server Builder" "" "Please enter a user name:")
    assignMenu USER_MENU
    while read UNAME
    do
        if (( ${#UNAME} == 0 ))
        then
            UNAME="default"
        fi
        USER_MENU=("NEW USER" "This is the first time you've used Server Builder" "" "Is $UNAME correct?" "[Y]es [N]o")
        assignMenu USER_MENU
        while read -n1 -s KEY
        do
            case $KEY in
                y)
                    USER=$UNAME
                    break 2
                ;;
                n)
                    USER_MENU=("NEW USER" "This is the first time you've used Server Builder" "" "Please enter a user name:")
                    assignMenu USER_MENU
                    break
                ;;
            esac
        done
    done
    USER_MENU=("NEW USER" "Welcome, $USER" "" "Please enter a password:")
    assignMenu USER_MENU
    PREV_PWD="0"
    while read -s PWD
    do
        if [ "${#PWD}" -ge 4 ] && [[ $PWD =~ [[:lower:]] ]] && [[ $PWD =~ [[:upper:]] ]] && [[ $PWD =~ [[:digit:]] ]]
        then
            if [[ $PREV_PWD == $PWD ]]
            then
                PASSWORD=$PWD
                break
            elif [[ $PREV_PWD == "0" ]]
            then
                USER_MENU=("NEW USER" "Welcome, $USER" "" "Confirm password:")
                assignMenu USER_MENU
                PREV_PWD=$PWD
            else
                USER_MENU=("NEW USER" "Welcome, $USER" "" "Passwords must match" "Please enter a password:")
                assignMenu USER_MENU
                PREV_PWD="0"
            fi
        else
            USER_MENU=("NEW USER" "Welcome, $USER" "Password must contain at least 1 lowercase character" "Password must contain at least 1 uppercase character" "Password must contain at least 1 digit" "" "Please enter a password:")
            assignMenu USER_MENU
        fi
    done
    saveSettings
    return
}
# ==================== | Server Routines | ==================== #
buildBlocks(){
    if [ ! -d ./apps ]
    then
        mkdir apps
    fi
    echo "# Initial server set up" > /tmp/default
    for (( I=0; I<${#SUBDOMAINS[@]}; I++ ))
    do
        BLOCK=$(<SERVER_BLOCK)
        if [ ${SUBDOMAINS[$I]} == "www" ]
        then
            D="${SETTINGS[DOMAIN]} ${SUBDOMAINS[$I]}.${SETTINGS[DOMAIN]}"
        else
            D="${SUBDOMAINS[$I]}.${SETTINGS[DOMAIN]}"
        fi
        PORT=$(( 9001 + $I ))
        echo $BLOCK | sed "s/\[DOMAIN\]/$D/g" | sed "s/\[PORT\]/$PORT/g" >> /tmp/default
        echo -n "" > ./apps/${SUBDOMAINS[$I]}.js
        while read LINE
        do
            for KEY in "${!SETTINGS[@]}"
            do
                LINE=$(echo $LINE | sed "s/\[DOMAIN\]/${SUBDOMAINS[$I]}/g")
                case $LINE in
                    *$KEY*)
                        LINE=$(echo $LINE | sed "s/\[$KEY\]/${SETTINGS[$KEY]}/g")
                    ;;
                esac
                LINE=$(echo $LINE | sed "s/\[PORT\]/$PORT/g")
            done
            echo $LINE >> ./apps/${SUBDOMAINS[$I]}.js
        done < ./APP_STUB
    done
    echo false > page
    sleep .1
    if [ -e page ]
    then
        rm page
    fi
    return
}
makeExpect(){
    echo -n "" > ./EXPECT.sh
    SUBD_STR="${SUBDOMAINS[@]}"
    while read LINE
    do
        for KEY in "${!SETTINGS[@]}"
        do
            case $LINE in
                *$KEY*)
                    LINE=$(echo $LINE | sed "s/\[$KEY\]/${SETTINGS[$KEY]}/g")
                ;;
            esac
        done
        LINE=$(echo $LINE | sed "s/\[SUBDOMAINS\]/$SUBD_STR/g")
        echo $LINE >> ./EXPECT.sh
    done < ./expect/$1
    chmod +x ./EXPECT.sh
    ./EXPECT.sh >/dev/null
    rm ./EXPECT.sh
    echo false > page
    sleep .1
    if [ -e page ]
    then
        rm page
    fi
    return
}
