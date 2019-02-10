# exowings-debian
Repositorio de archivos varios e instrucciones para hacer funcionar Fedora GNU/Linux en la notebook Exo Wings K2200.


Hardware:
=========
- CPU: Intel(R) Atom(TM) x5-Z8300  CPU @ 1.44GHz (CherryTrail)
- RAM: 2 GB DIMM DDR3 Synchronous 1066 MHz (0,9 ns)
- Video: VGA compatible controller: Intel Corporation Atom/Celeron/Pentium Processor x5-E8000/J3xxx/N3xxx Series PCI Configuration Registers (rev 22)
- Audio: Ensoniq es8316 (Intel SST)
- WiFi: AMPAK AP6212 - Broadcom 43438a0
- Bluetooth: AMPAK AP6212 - ?
- Touchscreen: Silead gsl1680
- Touchpad: 1017:1006 Speedy Industrial Supplies, Pte., Ltd
- Teclado: 1017:1006 Speedy Industrial Supplies, Pte., Ltd
- Pantalla: Resolución máxima 800x1280
- Acelerometro: Bosch 0200
- Cámara delantera: Omnivision OVTI2680
- Cámara trasera:  Omnivision OVTI2680

ICs
===
- 1x GSl3676
- 1x AP6212
- 1x ES8316 - EB34X405
- 4x 6MP47 - D9SHD
- 1x SR29Z
- 1x BJT631 - 25lQ64CVIG
- 1x AXP288C

Instalación
=========== 
Fedora 29: Para instalar Fedora, simplemente bajen la imagen live que incluye el instalador. En mi caso instalé la versión X64. Si quieren instalar la versión de 32 bits, va a ser necesario mezclar ambos sistemas, ya que el live de fedora de 32 bits no incluye un bootloader UEFI.


WiFi
====
La notebook integra un adaptador SDIO combinado de Wifi+Bluetooth, un AMPAK AP6212. Fedora viene con el módulo preinstalado en el kernel, solamente hay que copiar el firmware que incluyo en la carpeta "Firmware":

sudo cp nvram.txt /lib/firmware/brcm/brcmfmac43430a0-sdio.txt


Teclado
=======
Funciona correctamente.


Touchpad
========
Funciona correctamente.

Bluetooth
=========
Funciona correctamente, copiar el siguiente archivo:

sudo cp bcm43438a0.hcd /lib/firmware/brcm/BCM4343A0.hcd


Touchscreen
===========
Funciona, es necesario copiar el firmware que incluyo:

sudo cp firmware_00.fw /lib/firmware/silead/mssl1680.fw

Luego configurar la matriz con los siguientes pasos:

1) Crear un archivo de configuración:
sudo touch /etc/udev/rules.d/98-touchscreen-cal.rules

2) Editarlo y copiar el texto incluido:
sudo vi /etc/udev/rules.d/98-touchscreen-cal.rules

ATTRS{name}=="silead_ts", ENV{LIBINPUT_CALIBRATION_MATRIX}="3.5687 0.0 -2.5710 0.0 2.3529 0.0132"


3) Recargar reglar de udev:
sudo udevadm control --reload-rules
sudo udevadm trigger

NOTA: Todavía no logro obtener la matriz de rotación correcta.

Audio
=====
Funciona, es necesario copiar los archivos de configuración de ALSA que incluyo:

sudo mkdir /usr/share/alsa/ucm/bytcht-es8316
sudo cp HiFi /usr/share/alsa/ucm/bytcht-es8316/
sudo cp bytcht-es8316.conf /usr/share/alsa/ucm/bytcht-es8316/

Reiniciar y debería funcionar. El switcheo de parlantes y auriculares no funciona correctamente, es un tema de un control GPIO.

Acelerómetro
============
La pantalla viene por defecto configurada en modo vertical, para rotarla permanentemente es necesario ajustar el acelerómetro. Entonces ejecutar lo siguiente:


1) Crear un archivo en "/usr/lib/udev/hwdb.d/" llamado "61-sensor-local.hwdb":

sudo touch /usr/lib/udev/hwdb.d/61-sensor-local.hwdb


2) Abrir el archivo y copiar el siguiente texto dentro del archivo:
sudo vi /usr/lib/udev/hwdb.d/61-sensor-local.hwdb

sensor:modalias:acpi:BOSC0200*:dmi:*:svnInsyde*:pnCherryTrail:*
  ACCEL_MOUNT_MATRIX=-1, 0, 0; 0, 1, 0; 0, 0, 1


3) Ejecutar los siguientes comandos:

sudo systemd-hwdb update
sudo udevadm trigger

