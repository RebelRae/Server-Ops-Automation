#!/usr/local/bin/bash
####################################################################################################################
###                                                                                                              ###
###                    SERVER OPS AUTOMATION WITH PROFILES                                                       ###
###                                                                                                              ###
###                    Author : Rebel Rae Brown                                                                  ###
###                    Email : Rebel@TheDeviantRebel.com                                                         ###
###                    Current Version : 0.1.1                                                                   ###
###                    Release Date : Tue Jan 25 08:42:57 PST 2022                                               ###
###                                                                                                              ###
###                    Support : PayPal.me/RebelRae                                                              ###
###                                                                                                              ###
####################################################################################################################

# ==================== | Inclue | ==================== #
source ROUTINES.sh
# ==================== | Startup | ==================== #
if [ ! -d ./users ]
then
    mkdir users
fi
if [ -z "$(ls -A ./users)" ]
then
    newUser
else
    USER_MENU=("USER MENU" "Please choose a user")
    USERS=($(ls -A ./users))
    for ((I=0; I<${#USERS[@]}; I++))
    do
        USER_MENU[${#USER_MENU[@]}]="[$I] ${USERS[$I]}"
    done
    USER_MENU[${#USER_MENU[@]}]=""
    USER_MENU[${#USER_MENU[@]}]="[N]ew User"
    USER_MENU[${#USER_MENU[@]}]="[D]elete User"
    USER_MENU[${#USER_MENU[@]}]="[Q]uit"
    assignMenu USER_MENU
    while read -n1 -s SEL
    do
        case $SEL in
            q)
                clear
                echo Bye
                exit 0
            ;;
            n)
                newUser
                USER_MENU=("USER MENU" "Please choose a user")
                USERS=($(ls -A ./users))
                for ((I=0; I<${#USERS[@]}; I++))
                do
                    USER_MENU[${#USER_MENU[@]}]="[$I] ${USERS[$I]}"
                done
                USER_MENU[${#USER_MENU[@]}]=""
                USER_MENU[${#USER_MENU[@]}]="[N]ew User"
                USER_MENU[${#USER_MENU[@]}]="[D]elete User"
                USER_MENU[${#USER_MENU[@]}]="[Q]uit"
                assignMenu USER_MENU
            ;;
            d)
                USER_MENU=("USER MENU" "Choose a user to delete")
                USERS=($(ls -A ./users))
                for ((I=0; I<${#USERS[@]}; I++))
                do
                    USER_MENU[${#USER_MENU[@]}]="[$I] delete ${USERS[$I]}"
                done
                USER_MENU[${#USER_MENU[@]}]=""
                USER_MENU[${#USER_MENU[@]}]="[E]xit"
                assignMenu USER_MENU
                while read -n1 -s SEL1
                do
                    case $SEL1 in
                        e)
                            USER_MENU=("USER MENU" "Please choose a user")
                            USERS=($(ls -A ./users))
                            for ((I=0; I<${#USERS[@]}; I++))
                            do
                                USER_MENU[${#USER_MENU[@]}]="[$I] ${USERS[$I]}"
                            done
                            USER_MENU[${#USER_MENU[@]}]=""
                            USER_MENU[${#USER_MENU[@]}]="[N]ew User"
                            USER_MENU[${#USER_MENU[@]}]="[D]elete User"
                            USER_MENU[${#USER_MENU[@]}]="[Q]uit"
                            assignMenu USER_MENU
                            break
                        ;;
                        ''|*[!0-9]*) ;;
                        *)
                            if (( $SEL1 < ${#USERS[@]} ))
                            then
                                USER_MENU=("USER MENU" "Are you sure you want to delete user ${USERS[$SEL1]}?" "" "[Y]es" "[N]o")
                                assignMenu USER_MENU
                                while read -s -n1 SEL2
                                do
                                    case $SEL2 in
                                        n)
                                            USER_MENU=("USER MENU" "Please choose a user")
                                            USERS=($(ls -A ./users))
                                            for ((I=0; I<${#USERS[@]}; I++))
                                            do
                                                USER_MENU[${#USER_MENU[@]}]="[$I] ${USERS[$I]}"
                                            done
                                            USER_MENU[${#USER_MENU[@]}]=""
                                            USER_MENU[${#USER_MENU[@]}]="[N]ew User"
                                            USER_MENU[${#USER_MENU[@]}]="[D]elete User"
                                            USER_MENU[${#USER_MENU[@]}]="[Q]uit"
                                            assignMenu USER_MENU
                                            break 2
                                        ;;
                                        y)
                                            rm ./users/${USERS[$SEL1]}
                                            USER_MENU=("USER MENU" "Please choose a user")
                                            USERS=($(ls -A ./users))
                                            for ((I=0; I<${#USERS[@]}; I++))
                                            do
                                                USER_MENU[${#USER_MENU[@]}]="[$I] ${USERS[$I]}"
                                            done
                                            USER_MENU[${#USER_MENU[@]}]=""
                                            USER_MENU[${#USER_MENU[@]}]="[N]ew User"
                                            USER_MENU[${#USER_MENU[@]}]="[D]elete User"
                                            USER_MENU[${#USER_MENU[@]}]="[Q]uit"
                                            assignMenu USER_MENU
                                            break 2
                                        ;;
                                    esac
                                done
                            fi
                        ;;
                    esac
                done
            ;;
            ''|*[!0-9]*) ;;
            *)
                if (( $SEL < ${#USERS[@]} ))
                then
                    USER=${USERS[$SEL]}
                    break
                fi
            ;;
        esac
    done
    USER_MENU=("USER MENU" "Welcome, $USER" "Please enter a password:")
    assignMenu USER_MENU
    while read -s PWD
    do
        if [ "${#PWD}" -ge 4 ] && [[ $PWD =~ [[:lower:]] ]] && [[ $PWD =~ [[:upper:]] ]] && [[ $PWD =~ [[:digit:]] ]]
        then
            PASSWORD=$PWD
            TEST=$(testUser)
            if [ $TEST == true ]
            then
                loadSettings
                break
            else
                USER_MENU=("USER MENU" "Password for $USER incorrect" "Please enter a password:")
                assignMenu USER_MENU
            fi
        else
            USER_MENU=("USER MENU" "Welcome, $USER" "Password must contain at least 1 lowercase character" "Password must contain at least 1 uppercase character" "Password must contain at least 1 digit" "Please enter a password:")
            assignMenu USER_MENU
        fi
    done
    saveSettings
fi
# ==================== | Application | ==================== #
loadSettings
assignMenu MAIN
while read -n1 -s KEY
do
    case $KEY in
        c) assignMenu CREDITS ;;
        m) assignMenu MAIN ;;
        r)
            SERVER_MENU=("SERVER MENU" "Choose a server script to run")
            SCRIPTS=($(ls -A ./expect))
            for ((I=0; I<${#SCRIPTS[@]}; I++))
            do
                SERVER_MENU[${#SERVER_MENU[@]}]="[$I] ${SCRIPTS[$I]}"
            done
            SERVER_MENU[${#SERVER_MENU[@]}]=""
            SERVER_MENU[${#SERVER_MENU[@]}]="[B]uild server blocks and apps"
            SERVER_MENU[${#SERVER_MENU[@]}]=""
            SERVER_MENU[${#SERVER_MENU[@]}]="[M]ain Menu"
            assignMenu SERVER_MENU
            while read -n1 -s SEL
            do
                case $SEL in
                    m)
                        assignMenu MAIN
                        break
                    ;;
                    b)
                        SERVER_MENU=(
                            "SERVER MENU"
                            "Running server block build" ""
                            "This may take a few minutes"
                        )
                        assignMenu SERVER_MENU
                        buildBlocks & loading
                        SERVER_MENU=("SERVER MENU" "Finished!" "" "Press any key to continue")
                        assignMenu SERVER_MENU
                        read -s -n1
                        SERVER_MENU=("SERVER MENU" "Choose a server script to run")
                        SCRIPTS=($(ls -A ./expect))
                        for ((I=0; I<${#SCRIPTS[@]}; I++))
                        do
                            SERVER_MENU[${#SERVER_MENU[@]}]="[$I] ${SCRIPTS[$I]}"
                        done
                        SERVER_MENU[${#SERVER_MENU[@]}]=""
                        SERVER_MENU[${#SERVER_MENU[@]}]="[B]uild server blocks and apps"
                        SERVER_MENU[${#SERVER_MENU[@]}]=""
                        SERVER_MENU[${#SERVER_MENU[@]}]="[M]ain Menu"
                        assignMenu SERVER_MENU
                    ;;
                    ''|*[!0-9]*) ;;
                    *)
                        if (( $SEL < ${#SCRIPTS[@]} ))
                        then
                            SERVER_MENU=(
                                "SERVER MENU"
                                "Running server script ${SCRIPTS[$SEL]}" ""
                                "This may take a few minutes"
                            )
                            assignMenu SERVER_MENU
                            makeExpect ${SCRIPTS[$SEL]} & loading
                            SERVER_MENU=("SERVER MENU" "Finished!" "" "Press any key to continue")
                            assignMenu SERVER_MENU
                            read -s -n1
                            SERVER_MENU=("SERVER MENU" "Choose a server script to run")
                            SCRIPTS=($(ls -A ./expect))
                            for ((I=0; I<${#SCRIPTS[@]}; I++))
                            do
                                SERVER_MENU[${#SERVER_MENU[@]}]="[$I] ${SCRIPTS[$I]}"
                            done
                            SERVER_MENU[${#SERVER_MENU[@]}]=""
                            SERVER_MENU[${#SERVER_MENU[@]}]="[B]uild server blocks and apps"
                            SERVER_MENU[${#SERVER_MENU[@]}]=""
                            SERVER_MENU[${#SERVER_MENU[@]}]="[M]ain Menu"
                            assignMenu SERVER_MENU
                        fi
                    ;;
                esac
            done
        ;;
        h) assignMenu HELP ;;
        s)
            assignMenu SETTINGS_WIZARD
            while read -n1 -s REPLY
            do
                case $REPLY in
                    u)
                        updateSettings
                        assignMenu SETTINGS_WIZARD
                    ;;
                    a)
                        VAL_MENU=("SETTINGS WIZARD" "Enter key name:")
                        assignMenu VAL_MENU
                        read KEY
                        VAL_MENU=("SETTINGS WIZARD" "Enter value:")
                        assignMenu VAL_MENU
                        read VAL
                        SETTINGS[$KEY]=$VAL
                        saveSettings
                        assignMenu SETTINGS_WIZARD
                    ;;
                    d)
                        VAL_MENU=("SETTINGS WIZARD" "Enter number of key to delete:" "")
                        declare -A NUM_ARR
                        NUM_ARR=()
                        I=${#VAL_MENU[@]}
                        J=0
                        for K in "${!SETTINGS[@]}"
                        do
                            VAL_MENU[$I]="[$J] $K"
                            NUM_ARR[$J]=$K
                            ((I++))
                            ((J++))
                        done
                        VAL_MENU[$I]=""
                        ((I++))
                        VAL_MENU[$I]="[E]xit Deletion"
                        assignMenu VAL_MENU
                        while read K
                        do
                            case $K in
                                e)
                                    assignMenu SETTINGS_WIZARD
                                    break
                                ;;
                                ''|*[!0-9]*) ;;
                                *)
                                    if (( $K < ${#NUM_ARR[@]} ))
                                    then
                                        VAL_MENU=("SETTINGS WIZARD" "Are you sure you want to delete the setting ${NUM_ARR[$K]}?" "" "[Y]es" "[N]o")
                                        assignMenu VAL_MENU
                                        while read -s -n1 L
                                        do
                                            case $L in
                                                y)
                                                    deleteSetting ${NUM_ARR[$K]}
                                                    break 2
                                                ;;
                                                n) break 2 ;;
                                            esac
                                        done
                                    fi
                                ;;
                            esac
                        done
                        assignMenu SETTINGS_WIZARD
                    ;;
                    r)
                        CONFIRM=("RESET SETTINGS" "This will erase your current settings file." "" "Are you sure?" "" "Type [YES] to confirm or [NO] to go back.")
                        assignMenu CONFIRM
                        while read REPLY
                        do
                            declare -l REPLY
                            case $REPLY in
                                yes)
                                    clearSettings
                                    CONFIRM=("RESET SETTINGS" "Your settings have been erased!" "" "Press any key to continue.")
                                    assignMenu CONFIRM
                                    read -s
                                    assignMenu SETTINGS_WIZARD
                                    break
                                ;;
                                no)
                                    assignMenu SETTINGS_WIZARD
                                    break
                                ;;
                            esac
                        done
                    ;;
                    m)
                        assignMenu MAIN
                        break
                    ;;
                    q)
                        clear
                        echo Bye
                        exit 0
                    ;;
                    *) ;;
                esac
            done
        ;;
        q) break ;;
    esac
done
clear
echo Bye