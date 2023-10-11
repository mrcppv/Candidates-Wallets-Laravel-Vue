# Reading on git cli and linux shell commands
Here are a few articles explaining the basics for git and linux, which will come in handy when working with WSL:

1. [Git tutorial for beginners](https://linuxconfig.org/git-tutorial-for-beginners)
2. [Command line for beginners](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)
3. [Docker and Docker Compose commands cheatsheet](https://aws.plainenglish.io/the-ultimate-cheat-sheet-for-basic-docker-and-git-docker-compose-6e08e3f861da)


# Configuring the local environment (Windows + WSL)

## Install and configure WSL, Ubuntu
Before anything else, the environment requires WSL and Ubuntu to be installed on Windows, as seen in [this article](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview) *
After installation, a new shell profile will be added in Windows Terminal. It is recommended to use this from now on, as it is the most feature-rich of all options.

>**NOTE:**
>
>When installing Ubuntu, you will be prompted for a username and password. Remember this password, as it will be needed later.

>**NOTE:**
>
> From this point forward, all command line commands/scripts will be run in a new Ubuntu terminal(not powershell, or git bash, or cmd). In order to use it, open a Microsoft Terminal instance, click on the down arrow next to the new tab button, and select the Ubuntu profile, as shown below.
![Ubuntu profile for terminal](./readme/terminal-profile.png)

## Install docker desktop
1. Download Docker Desktop ( https://docs.docker.com/get-docker/ )
2. Install Docker Desktop


## Configure Visual Studio Code
Before we run the project, we need to configure VS Code to be able to work with WSL and Docker. For this, we need to install extensions for the two, as seen below:

![WSL Extension](./readme/vscode-wsl-extension.png)
![Docker extension](./readme/vscode-docker-extension.png)



## Run VS Code in WSL
You need first to connect to WSL with VS Code. Go at the bottom left of the window and click on this button ![Connect to WSL](./readme/vscode_connect_to_wsl.png) then select Connect to WSL in a New Window. Now you are running VS Code in Ubuntu, you need to open the project from Ubuntu, not from your regular Windows folders. From here on, each terminal window you open will be in WSL.

# Running the project
In a terminal window (opened in Ubuntu as instructed earlier), navigate to the project's folder (and, if needed, switch to your desired branch):

```sh
sudo mount -t drvfs <drive_letter>:/ /mnt/<mount_point>
```

Replace <drive_letter> with the drive letter of the Windows folder that you want to mount and <mount_point> with the mount point that you created in step 3.

For example, to mount the Windows folder C:\Users\John Doe\Desktop to the mount point /mnt/windows, you would run the following command:

```sh
sudo mount -t drvfs C:/ /mnt/windows

```

Once the Windows folder is mounted, you can access it from WSL like any other directory. For example, to list the contents of the Windows folder, you would run the following command:

```sh
ls /mnt/windows
```

Run the initialization script to clean the project folder and build the docker images:
```sh
sudo ./scripts/init.sh
```

This command will require the password created in the beginning. It will do the following:
 - Copy `.env.example` to `.env`
 - Build the docker images. When the images are started, they will automatically install the latest dependencies for php (`composer install`) 


After this, we can start running the project. Make sure Docker Desktop is running and **that there are no other containers running using the same port 80. Turn them off if that's the case**, then run the start script:

```sh
./scripts/start.sh
```

This will run the docker-compose command which will pull the images and build the containers.

> **Note**
>
> In order to stop the containers, we need to run the following command:
>
>`./scripts/stop.sh`
>
> Or if something went wrong and some errors were produced, you could restart the process with:
> 
>`./scripts/restart.sh`

Run yarn to install all dependencies:
`./scripts/yarn.sh install`

After you have composer and all of the dependancies installed we can now start the dev server:
`php aartisan key:generate`
`npm install`

The application needs to run above PHP v 8.1 so make sure to select it:
`npm run dev C:\wamp64\bin\php\php8.1.13\php.exe artisan serve --host=127.0.0.1 --port=8000`


Only when setting up the project for the first time:
`php artisan migrate`
`php artisan db:seed`


# Updating dependencies, migrations
It is recommended to keep the application up to date regarding its dependencies. Every once in a while we should update/install the dependencies to make sure we are on the latest versions.
For PHP, whenever the `composer.json` file changes run:
```sh
./scripts/composer.sh update
```

For JS/TS, whenever the `package.json` file changes run:
```sh
./scripts/yarn.sh install
```

When the database migrations are updated, the migration script needs to be run. For this, run the following:
```
./scripts/artisan.sh migrate
```


# Scripts
The repo contains a few *.sh* scripts located in the scripts folder, which should make running commands in docker easier:

1. **artisah.sh**: Used to run artisan commands for laravel, in the app container. Its usage is exactly like the artisan command in laravel. E.g: `./scripts/artisan.sh migrate:fresh`
2. **bash.sh**: Used to start a new shell/terminal inside the specified container. Usage: `./scripts/bash.sh [CONTAINER_NAME]` (app or pgsql)
3. **build.sh** Used to build the frontend using `yarn prod`. It doesn't require any arguments. Usage: `./scripts/build.sh`
4. **composer.sh**: Similar to **artisan.sh**, it is used to run composer commands inside the app container. Its usage is identical to the composer command: `./scripts/composer.sh install`
6. **docker.sh**: Used to run docker-compose commands. Can be used to run commands not covered by any of the other sh scripts. (such as *docker compose ps*, *docker compose ls*, etc.). It is used exactly like the *docker-compose* or *docker compose* commands. E.g: `./scripts/docker.sh up -d`, `./scripts/docker.sh ps`. Read more on docker compose commands in the links at the top.
7. **exec.sh**: Executes a cli command inside the specified container. Usage: `./scripts/exec.sh [CONTAINER_NAME] [COMMAND]`. E.g: `./scripts/exec.sh app ls`
8. **init.sh** Makes sure the files and folders have the right ownership and permissions. Does not require any arguments. THIS SHOULD BE RUN AS ROOT (e.g. with sudo)
9. **logs.sh**: Outputs the logs for a specific container. Its only argument is the container name: `./scripts/logs.sh app`
10. **restart.sh**: Stops and starts the docker containers again. Does not need any arguments.
11. **start.sh**: Starts the docker containers
12. **stop.sh**: Stops the docker containers
13. **yarn.sh**: Similar to **artisan.sh** and **composer.sh**, this runs yarn commands inside the app container. Its usage is exactly the same as the yarn command. For example: `./scripts/yarn.sh install`



# Useful docker commands
https://docswiki.newro.co/index.php/Docker_Tutorial (just ignore `sudo` keyword when typing commands)



# Q & A
**How do I reinitialize the application?**
1. Open Docker Desktop
2. From Left Panel go to -> Containers, Volumes and Images delete everything.
3. Inside a Ubuntu Terminal, go to the project folder and run again  `./scripts/start.sh`

**Docker application consumes too much RAM (see the GUI footer). What should I do?**
1. Open a Command Prompt console
2. Run the command: `docker system prune -a`
