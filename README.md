# Credits to rameshgkwd05
forked off from https://github.com/rameshgkwd05/Battery-Checker-Script-for-mint-ubuntu

# Battery-Checker-Script-for-mint-ubuntu
A Battery Monitor script for Linux Mint/Ubuntu.
This script works with upstart and systemd if you use the Makefile.
Once started it polls for every 5 minutes. (see TODO)
It Checks Battery percentage. If it is less than 18% then prompts a low-battery-sound 3 times.
(You can modify chekpc parameter in the script to other than 18) (see TODO)


# Clone the Repo
` git clone https://github.com/Mangnoppa/Battery-Checker-Script-for-mint-ubuntu.git`

# Usage
- Clone the repository

- ` cd Battery-Checker-Script-for-mint-ubuntu` or the name you gave the folder

- ` make` or ` sudo make`

- ` make install_dep` if you only want to install the mp3.file and the dependencies

# ATTENTION
The script and the Makefile is under development. It is tested with upstart (Mint 17.3) and systemd (Ubuntu 16.04)

If you don't want to use the Makefile, follow the instructions from the
original repository at https://github.com/rameshgkwd05/Battery-Checker-Script-for-mint-ubuntu

# TODO
- Open a window with dropdownlist, in/from Makefile, to choose for which battery the script should be installed

- Make poll-interval variable

- Make percentage variable

- If sound is muted, only show a message -> no sound
