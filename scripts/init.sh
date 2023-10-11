#!/usr/bin/env bash

clear;

## Variables which will be used in the script
SCRIPT_LOCATION="$(dirname "$0")"
source $SCRIPT_LOCATION/vars.sh
LOGGED_USER=${SUDO_USER:-$USER}
LOG_FILE="${PWD}/storage/logs/build/$(uuidgen)-install.log"

# Create the log file
touch $LOG_FILE;


##### Functions
## Log a message in the log file
log() {
    MESSAGE=${1}
    echo $MESSAGE >> $LOG_FILE 2>&1
}


## Run a command and log its output in the log file
run() {
    "$@" >> $LOG_FILE 2>&1
}


{
    ## CHMOD and CHOWN the project's files and folders
    echo -e "XXX\n0\nConfiguring permissions and owner for project files and folder. New files owner: ${LOGGED_USER}\nXXX"
    log "Configuring permissions and owner for project files and folder. New files owner: ${LOGGED_USER}"
    run chown -R $(id -u $LOGGED_USER):$(id -g $LOGGED_USER) ./
    run chmod u+x ./scripts/*
    run chmod +x ./scripts/*
    run chmod u+x ./docker/images/app/20-supervisor.sh ./docker/images/app/30-init.sh
    run chmod +x ./docker/images/app/20-supervisor.sh ./docker/images/app/30-init.sh
    sleep 0.2


    ## If we already have an .env file, make a backup and generate a new one from the .env.example file
    if [ -f ".env" ]; then
        echo -e "XXX\n25\nFound old .env file. Backing up to .env.bak\nXXX"
        log "Found old .env file. Backing up to .env.bak"
        run rm -f .env.bak && mv .env .env.bak
    fi
    echo -e "XXX\n30\nGenerating new .env file\nXXX"
    log "Generating new .env file"
    run cp .env.example .env
    sleep 0.2




} | whiptail --title "Configuring environment" --gauge "Please wait while the script runs..." 6 100 0


## ALlow the user to configure the .env file
whiptail \
    --title "Configuring environment" \
    --msgbox "Before we build the container images, please open the .env file in VSCode (or another editor), make any changes necessary, and save it. After you have saved the file, press OK or Enter to continue with the configuration." \
    8 100

{

    ## Start building the docker compose images.
    echo -e "XXX\n75\nBuilding docker-compose images. This might take a while (in some cases up to 30-60 minutes, depending on CPU). Please be patient.\nXXX"
    log "Building docker-compose images. This might take a while (in some cases up to 30-60 minutes, depending on CPU). Please be patient."
    source .env
    run docker compose build
    sleep 0.2

} | whiptail --title "Configuring environment" --gauge "Please wait while the script runs..." 6 100 0


# End
whiptail \
    --title "Configuring environment" \
    --msgbox "Finished configuring the project and building the images. You may now start docker using the start.sh script. A log file was saved in ${LOG_FILE}." \
    8 100

echo "Done!"
echo "Log file saved in: ${LOG_FILE}"
