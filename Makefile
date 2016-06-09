PROG = BatteryChecker.sh
BIN_PATH = /usr/local/bin/

MP3_ZIP_URL = http://www.orangefreesounds.com/wp-content/uploads/Zip/Low-battery-sound.zip
MP3_ZIP = Low-battery-sound.zip
MP3 = Low-battery-sound.mp3

DEP_LIST = alsa sox libsox-fmt-mp3
INSTALL_TARGETS = install_dep install_prog

RC_LOCAL_PATH = /etc/rc.local
TMP_RC_LOCAL = test.rc
EXEC_AT_BOOT = (/bin/sleep 10 && ${BIN_PATH}${PROG})

SYSTEMD_SERVICE_FILE = batterychecker.service
SYSTEMD_PATH = /etc/systemd/system/

INIT_SYS := $(shell cat /proc/1/comm )
ALREADY_IN := $(shell cat /etc/rc.local | grep ${PROG})

ifeq ($(INIT_SYS), init)
install: $(INSTALL_TARGETS) upstart
endif

ifeq ($(INIT_SYS), systemd)
install: $(INSTALL_TARGETS) systemd
endif 

install: clean

install_prog:
	@sudo cp $(PROG) $(BIN_PATH)
	@sudo chown $$USER:$$USER $(BIN_PATH)$(PROG)

upstart:
ifneq ($(ALREADY_IN), $(EXEC_AT_BOOT))
	@sudo cp ${RC_LOCAL_PATH} ${RC_LOCAL_PATH}.bak
	@sudo sh -c "sed 's#exit 0\$$#(/bin/sleep 10 \&\& ${BIN_PATH}${PROG})\n\nexit 0#' ${RC_LOCAL_PATH} > $(TMP_RC_LOCAL)"
	@sudo chmod +x $(TMP_RC_LOCAL)
	@sudo cp $(TMP_RC_LOCAL) $(RC_LOCAL_PATH)
	@sudo rm $(TMP_RC_LOCAL)
endif

install_dep:
	@wget $(MP3_ZIP_URL)
	@unzip $(MP3_ZIP)
	@sudo cp $(MP3) /usr/share/sounds/
	@sudo apt-get install $(DEP_LIST)

systemd: make_service_file
	@sudo cp ${SYSTEMD_SERVICE_FILE} ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@chown root:root ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@sudo chmod 664 ${SYSTEMD_PATH}${SYSTEMD_SERVICE_FILE}
	@rm ${SYSTEMD_SERVICE_FILE}
	@systemctl enable ${SYSTEMD_SERVICE_FILE}
	
	
make_service_file:
	@touch ${SYSTEMD_SERVICE_FILE}
	@echo "[unit]\nDescription=Sound-warning on low battery\n" > ${SYSTEMD_SERVICE_FILE}
	@echo "[Service]\nType=oneshot\nExecStart=${BIN_PATH}${PROG}\n" >> ${SYSTEMD_SERVICE_FILE}
	@echo "[Install]\nWantedBy=multi-user.target" >> ${SYSTEMD_SERVICE_FILE}	

clean:
	@rm *.zip* *.txt $(MP3)

# write debug as dependencie of clean for testing this Makefile
debug:
	@sudo rm /usr/share/sounds/$(MP3)
	@sudo rm ${BIN_PATH}$(PROG)
