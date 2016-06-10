# Systemd is not tested yet!

PROG = BatteryCheckerScript.sh
BIN_PATH = /usr/local/bin/

MP3_ZIP_URL = http://www.orangefreesounds.com/wp-content/uploads/Zip/Low-battery-sound.zip
MP3_ZIP = Low-battery-sound.zip
MP3 = Low-battery-sound.mp3

DEP_LIST = alsa sox libsox-fmt-mp3
INSTALL_TARGETS = install_dep install_prog

INIT_CONFIG_FILE = batterychecker.conf
INIT_PATH = /etc/init/

SYSTEMD_SERVICE_FILE = batterychecker.service
SYSTEMD_PATH = /etc/systemd/system/

INIT_SYS := $(shell cat /proc/1/comm )
ALREADY_IN := $(shell cat /etc/rc.local | grep ${PROG})

ifeq (${INIT_SYS}, init)
install: ${INSTALL_TARGETS} upstart
endif

ifeq (${INIT_SYS}, systemd)
install: ${INSTALL_TARGETS} systemd
endif

install: clean

# copy PROG to /usr/local/bin
install_prog:
	@sudo cp ${PROG} ${BIN_PATH}
	@sudo chown $$USER:$$USER ${BIN_PATH}${PROG}

# copy .conf-file to /etc/init, change owner to root:root and start
upstart: make_config_file
	@sudo cp ${INIT_CONFIG_FILE} ${INIT_PATH}${INIT_CONFIG_FILE}
	@sudo chown root:root ${INIT_PATH}${INIT_CONFIG_FILE}
	@rm ${INIT_CONFIG_FILE}
	@sudo start batterychecker

# make the .conf-file for BatteryCheckerScript.sh
make_config_file:
	@touch ${INIT_CONFIG_FILE}
	@echo "description 'Starting BatteryChecker'" > ${INIT_CONFIG_FILE}
	@echo "author 'Mangnoppa <mangnoppa@arcor.de>'\n" >> ${INIT_CONFIG_FILE}
	@echo "start on runlevel [2345]\n" >> ${INIT_CONFIG_FILE}
	@echo "stop on runlevel [016]\n" >> ${INIT_CONFIG_FILE}
	@echo "respawn\n" >> ${INIT_CONFIG_FILE}
	@echo "chdir /usr/local/bin/\n" >> ${INIT_CONFIG_FILE}
	@echo "exec BatteryCheckerScript.sh" >> ${INIT_CONFIG_FILE}

# download mp3.zip, unzip, copy to /usr/share/sounds and install dependencies
install_dep:
	@wget ${MP3_ZIP_URL}
	@unzip ${MP3_ZIP}
	@sudo cp ${MP3} /usr/share/sounds/
	@sudo apt-get install ${DEP_LIST}

# copy .service-file to /etc/systemd/system/ change owner to root:root
# change permissions, rm tmp-service-file and start batterychecker
systemd: make_service_file
	@sudo cp ${SYSTEMD_SERVICE_FILE} ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@chown root:root ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@sudo chmod 664 ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@rm ${SYSTEMD_SERVICE_FILE}
	@systemctl enable ${SYSTEMD_SERVICE_FILE}

# make .service-file
make_service_file:
	@touch ${SYSTEMD_SERVICE_FILE}
	@echo "[unit]\nDescription=Sound-warning on low battery\n" > ${SYSTEMD_SERVICE_FILE}
	@echo "[Service]\nType=oneshot\nExecStart=${BIN_PATH}${PROG}\n" >> ${SYSTEMD_SERVICE_FILE}
	@echo "[Install]\nWantedBy=multi-user.target" >> ${SYSTEMD_SERVICE_FILE}

# cleaning directory
clean:
	@rm *.zip* *.txt ${MP3}

# write debug as dependencie of clean for testing this Makefile
debug:
	@sudo rm /usr/share/sounds/${MP3}
	@sudo rm ${BIN_PATH}${PROG}
