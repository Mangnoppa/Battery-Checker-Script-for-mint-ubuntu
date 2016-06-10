# Credits to rameshgkwd05
forked off from https://github.com/rameshgkwd05/Battery-Checker-Script-for-mint-ubuntu

# Battery-Checker-Script-for-mint-ubuntu
A Battery Monitor script for mint/ubuntu os. Once started it polls for every 5 minutes.
It Checks Battery percentage. If it is less than 18% then prompts a low-battery-sound 3 times.
(You can modify chekpc parameter in the script to other than 18)


# Clone the Repo
` git clone https://github.com/Mangnoppa/Battery-Checker-Script-for-mint-ubuntu.git`

# Usage
- Clone the repository

- ` cd Battery-Checker-Script-for-mint-ubuntu` or the name you gave the folder

- ` make` or ` sudo make`

- ` make install_dep` if you only want to install the mp3.file and the dependencies

# ATTENTION
The Makefile is under developement and is not tested with systemd.
If you don't want to use an untested Makefile, follow the instructions from the
original repository at https://github.com/rameshgkwd05/Battery-Checker-Script-for-mint-ubuntu
