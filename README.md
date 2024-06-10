php artisan generate:key
php artisan migrate
php artisan db:seed


# Step 1 — Install WSL 2

WSL2 (Windows Subsystem for Linux version 2) is a new version of the architecture that allows you to use Linux on top of Windows 10 natively (using a lightweight virtual machine) and replaces WSL.

The feature runs an actual Linux kernel in this new version, which improves performance and app compatibility over the previous version while maintaining the same experience as the first release.

>**NOTE**
>To install WSL 2 on Windows 10 you need:
>
>Windows 10 May 2020 (2004), Windows 10 May 2019 (1903), or Windows 10 November 2019 (1909) or later
>A computer with Hyper-V Virtualization support
>If you are using Windows 10, the first requirement is not necessary (lol)
>To install Windows Subsystem for Linux on Windows 10, use these steps:

Open Start on Windows 10.
Search for Command Prompt or Windows Powershell, right-click the top result, and select the Run as administrator option.
Type the following command to install the WSL on your Windows machine and press Enter:
```sh
wsl --install
```
Restart your computer to finish the WSL installation.
The above command will install all the WSL 2 components and the Ubuntu Linux distribution.

To install a specific Linux distribution, run:
```sh
wsl –install -d DISTRO-NAME.
```

To update the WSL2 kernel, run the command below:
```sh
wsl –update
```

For more details about WSL2 installation, kindly read the documentation.

# Step 2 — Download & Install Docker
To start using docker desktop, first you need to download the docker file for windows.
Your docker downloaded file can be found in your download folder.

Run the set up as Administrator.

Follow the Install Wizard: accept the license, authorize the installer, and proceed with the install.
Click on the Close button once the installation process is finished.
Ensure that your docker user account and administrator account should be the same, otherwise you need to add your user account to the docker user group.
After following all these steps, restart your computer to update and start docker desktop on your windows machine.
To ensure that WSL 2 is running on your docker desktop app:

Start Docker Desktop from the Windows Start menu.
From the Docker menu, select Settings > General.

Select the Use WSL 2 based engine check box. (If you have installed Docker Desktop on a system that supports WSL 2, this option will be enabled by default.)
Click Apply & Restart.
That’s it! Now docker commands will work from Windows using the new WSL 2 engine.

# Step 3 — 
Now that we have installed Docker Desktop successfully and Windows Subsystem for Linux 2 (WSL2) is installed and enabled, the next step is to select our Laravel project.

Go to the project folder directory and make sure that the .env has the correct information. 

Open your Windows Terminal as Administrator.
Head over to the location where your Laravel project is stored.
```sh
cd c:\wamp64\www\example-app
 ```
Only when setting up the project for the first time:
```php artisan migrate```
```php artisan db:seed```
```php aartisan key:generate```

Initialize WSL in that location by running the following command:
```sh
wsl
```

>**NOTE**
>SQL Lite
>
>To use a SQLite database in your Laravel project:
>
>Modify your .env :
>```
>DB_CONNECTION=sqlite
>```
>
>Modify config/database.php:
>```
>connections => sqlite 'database' => __DIR__ . '/../storage/app/db.sqlite',
>```
>I always recommend to put your SQLite database in the storage directory, as this directory should be the only one where your web server will have write >permission.
>
>Finally, create the database file:
>```
>touch storage/app/db.sqlite
>```

# Step 4— Starting the services
Laravel Sail provides a simple command-line interface for interacting with Laravel’s default Docker configuration.
With docker running, run the following command in the linux terminal.
```sh
./vendor/bin/sail up
```

**NOTE** Once the application’s Docker containers have been started, you can access the application in your web browser at: http://localhost.


By default, Sail commands are invoked using the vendor/bin/sail script that is included with all new Laravel applications. However, instead of repeatedly typing vendor/bin/sail to execute Sail commands, you may wish to configure a shell alias that allows you to execute Sail's commands more easily:
```sh
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
```


Once the shell alias has been configured, you may execute Sail commands by simply typing sail. The remainder of this documentation's examples will assume that you have configured this alias:
```sh
sail up
```

Before starting Sail, you should ensure that no other web servers or databases are running on your local computer. To start all of the Docker containers defined in your application’s docker-compose.yml file, you should execute the up command:
```sh
sail up
```

To start all of the Docker containers in the background, you may start Sail in “detached” mode:
```sh
sail up -d
```

To stop all of the containers, you may simply press Control + C to stop the container’s execution. Or, if the containers are running in the background, you may use the stop command:
```sh
sail stop
```
