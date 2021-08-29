prefix = /usr
datadir = ${prefix}/share
sysconfdir = /etc
firmwaredir = /lib/firmware
libdir = ${prefix}/lib

lang := $(shell LANG="$${LANG%.*}"; printf %s "$${LANG%_*}")

msg-ready-${lang} = Ready to install.
msg-ready-es = Listo para instalar.

.PHONY: all
all:
	@echo "${msg-ready-${lang}}"

.PHONY: install-firmware-wireless
install-firmware-wireless:
	install -d ${DEST}${firmwaredir}/brcm
	install -m644 firmware/brcmfmac43430a0-sdio.txt ${DEST}${firmwaredir}/brcm/
	install -m444 firmware/BCM4343A0.hcd ${DEST}${firmwaredir}/brcm/

.PHONY: install-firmware-touchscreen
install-firmware-touchscreen:
	install -d ${DEST}${firmwaredir}/silead
	install -m444 firmware/mssl1680.fw ${DEST}${firmwaredir}/silead/

.PHONY: install-firmware
install-firmware: install-firmware-wireless install-firmware-touchscreen

.PHONY: install-udev-conf
install-udev-conf:
	install -d ${DEST}${sysconfdir}/udev/rules.d
	install -m644 udev/*.rules ${DEST}${sysconfdir}/udev/rules.d/
	install -d ${DEST}${libdir}/udev/hwdb.d
	install -m644 udev/*.hwdb ${DEST}${libdir}/udev/hwdb.d/

.PHONY: install-alsa-conf
install-alsa-conf:
	install -d ${DEST}${datadir}/alsa/ucm/bytcht-es8316
	install -m644 alsa/HiFi ${DEST}${datadir}/alsa/ucm/bytcht-es8316/
	install -m644 alsa/bytcht-es8316.conf ${DEST}${datadir}/alsa/ucm/bytcht-es8316/

msg-udev-${lang} = You can now reload udev configuration running:
msg-udev-es = Ahora puedes recargar la configuración de udev ejecutando:

.PHONY: install
install: install-firmware install-udev-conf install-alsa-conf
	@echo "***"
	@echo "${msg-udev-${lang}}"
	@echo sudo udevadm control --reload-rules
	@echo sudo systemd-hwdb update
	@echo sudo udevadm trigger

# FIXME blinking issue after suspend&resume
# FIXME add drm/fbcon quirk for screen rotation (fbcon=rotate:3 isn't enough)
# FIXME fix sound card pin config / switching to headphones doesn't work
