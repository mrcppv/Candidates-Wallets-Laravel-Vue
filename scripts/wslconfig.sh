#!/usr/bin/env bash

clear;

LOGGED_USER=${SUDO_USER:-$USER}
LOG_FILE="${PWD}/install.log"

# Function to check if sudo works
correct_sudo_password() {
    PASS=${1}

    if sudo -lS &> /dev/null <<< $PASS
    then
        echo true
    else
        echo false
    fi
}

log() {
    MESSAGE=${1}
    echo $MESSAGE >> $LOG_FILE 2>&1
}

run() {
    "$@" >> $LOG_FILE 2>&1
}


# Show welcome message.
whiptail \
    --title "Digital Recording System" \
    --msgbox "Welcome to the digital recording system installation and initialization script. This script will configure everything the project needs to run under a Windows + WSL + Ubuntu + Docker environment. Press 'Enter' or 'OK' to continue. Press CTRL+C to cancel." \
    8 100


# Show root password input
SUDO_PASS=$(whiptail --title "Digital Recording System" --passwordbox "Enter your password and press Enter or Ok to continue." 10 100 3>&1 1>&2 2>&3)
exitstatus=$?

# If the user didn't enter a password, or hit cancel, exit
if [ $exitstatus != 0 ] || [ "$SUDO_PASS" = "" ]; then
    echo "The user has not entered a password, or has cancelled. Exiting installation."
    exit;
fi


# Check if the password entered is correct.
if [ $(correct_sudo_password $SUDO_PASS) = false ]; then
    # If the password is wrong, continue asking for a password untin the user
    #   enters a correct password, or cancels
    CORRECT_PASS=false

    while [ $CORRECT_PASS = false ]
    do
        SUDO_PASS=$(whiptail --title "Digital Recording System" --passwordbox "The previous password you entered was incorrect. Enter your password and press Enter or Ok to continue." 10 100 3>&1 1>&2 2>&3)
        exitstatus=$?

        if [ $exitstatus != 0 ] || [ "$SUDO_PASS" = "" ]; then
            echo "The user has not entered a password, or has cancelled. Exiting installation."
            exit;
        fi

        CORRECT_PASS=$(correct_sudo_password $SUDO_PASS)
    done
fi


# Ask for an email address to be used with the SSH key
EMAIL=$(whiptail --inputbox "What is your newroco email address? (ending with @newro.co)" 8 39 @newro.co --title "Digital Recording System" 3>&1 1>&2 2>&3)
exitstatus=$?


# If the user didn't input an email address, or hit cancel, exit.
if [ $exitstatus != 0 ] || [ "$EMAIL" = "" ] || [ "$EMAIL" = "@newro.co" ]; then
    echo "User selected Cancel, or has entered an invalid email address. Stopping configuration."
    exit;
fi

echo "User selected OK. Email address selected: ${EMAIL}."
log "User selected OK. Email address selected: ${EMAIL}."
log "Continuing with configuration...".


## Start the progress bar (gauge)
{
    # Install dependencies (git, curl, etc.)
    echo -e "XXX\n0\nInstalling required dependencies...\nXXX"
    log "Installing required dependencies..."
    run sudo -S <<< $SUDO_PASS apt-get -y install curl git
    sleep 0.2


    ## Generate a ssh key in ~/.ssh/newroco/
    echo -e "XXX\n10\nGenerating ssh key\nXXX"
    log "Generating ssh key"
    if [ -d ~/.ssh ]; then
        log "Backing up ~/.ssh folder"
        if [ -d ~/.ssh.bak ]; then
            log "A backup already exists. Append a new extension".
            BAK_NO=1
            while [ -d ~/.ssh.bak.$BAK_NO ]
            do
                BAK_NO=$((BAK_NO + 1))
            done
            log "Backing up into ~/.ssh.bak.${BAK_NO}"
            run mv ~/.ssh ~/.ssh.bak.${BAK_NO}
        else
            run mv ~/.ssh ~/.ssh.bak
        fi
    fi
    run mkdir ~/.ssh
    run mkdir ~/.ssh/newroco
    run ssh-keygen -q -t ed25519 -C ${EMAIL} -f ~/.ssh/newroco/id_ed25519 -N ""
    sleep 0.2


    ## Start the ssh agent
    echo -e "XXX\n20\nStarting ssh agent\nXXX"
    log "Starting ssh agent"
    run eval "$(ssh-agent -s)"
    sleep 0.2

    ## Add the ssh key to the ssh agent
    echo -e "XXX\n30\nAdding SSH key to the SSH Agent\nXXX"
    log "Adding SSH key to the SSH Agent"
    run ssh-add ~/.ssh/newroco/id_ed25519
    sleep 0.2

    # Copy the ssh key to the user's clipboard
    echo -e "XXX\n40\nCopying the ssh key to clipboard\nXXX"
    log "Copying the ssh key to clipboard"
    cat ~/.ssh/newroco/id_ed25519.pub | clip.exe
    sleep 0.2

} | whiptail --title "Configuring DRS environment" --gauge "Please wait while the script runs..." 6 100 0


## Allow the user to enter the ssh key into gitlab, so it can be used.
whiptail \
    --title "Digital Recording System" \
    --msgbox "The new SSH key has been copied to your clipboard. Before continuing with the installation, please go to https://gitlab.newro.co/-/profile/keys and save your new key." \
    8 100


## Continue with the configuration process
{

    ## Make a backup of the current ssh config, and create a new one for gitlab.newro.co
    echo -e "XXX\n50\nConfiguring SSH agent for gitlab\nXXX"
    log "Configuring SSH agent for gitlab"
    echo 'AddKeysToAgent  yes
Host gitlab.newro.co
    HostName gitlab.newro.co
    ForwardAgent yes
    Port 15254
    Preferredauthentications publickey
    StrictHostKeyChecking=accept-new
    IdentityFile ~/.ssh/newroco/id_ed25519' > ~/.ssh/config
    sleep 0.2

    ## Clone the project
    echo -e "XXX\n60\Cloning the project in folder: digirec\nXXX"
    log "Creating the projects folder"
    run mkdir -p ~/Projects
    log "Cloning the project in folder: ~/Projects/digirec"
    run git clone git@gitlab.newro.co:oa/digirec.git ~/Projects/digirec

} | whiptail --title "Configuring DRS environment" --gauge "Please wait while the script runs..." 6 100 0


# End
whiptail \
    --title "Configuring DRS environment" \
    --msgbox "Finished configuring the VM and cloning the project. You may now `cd` into the project's folder and build the images using the `./scripts/init.sh` script. A log file was saved in ${LOG_FILE}." \
    8 100

echo "Done!"
echo "Log file saved in: ${LOG_FILE}"
