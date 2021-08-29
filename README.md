# exowings-fedora
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

Antes de comenzar debes tener instalada la utilidad `make`.

En Fedora:

	sudo dnf install make

En Debian y derivados (e.g. Huayra, Ubuntu):

	sudo apt-get install make

Para instalar el firmware y la configuración:

	sudo make install

WiFi
====
La notebook integra un adaptador SDIO combinado de Wifi+Bluetooth, un AMPAK AP6212. El driver está incluído en el kernel mainline.

Teclado
=======
Funciona correctamente.


Touchpad
========
Funciona correctamente.


Bluetooth
=========
Funciona correctamente.



Pantalla
========
El control de brillo funciona correctamente, aunque tiene un problema de parpadeo al volver luego de estar suspendido.

La consola aparece rotada, para ubicarla correctamente es necesario setear un parámetro en GRUB. Para ello, primero verificar el kernel que está booteando con el siguiente comando:

	sudo grubby --info=ALL

Luego buscar una linea que diga "index=0", la siguiente línea indicará el kernel que bootea. Por ejemplo "kernel=/boot/vmlinuz-4.20.6-200.fc29.x86_64"

Luego ejecutar el siguiente comando, cambiando "/boot/vmlinuz-4.20.6-200.fc29.x86_64" por el kernel que se haya listado arriba:


	sudo grubby --args=fbcon=rotate:3 --update-kernel /boot/vmlinuz-4.20.6-200.fc29.x86_64


Touchscreen
===========
Funciona.

Audio
=====
Funciona. El cambio entre parlantes y auriculares no funciona correctamente, es un tema de un control GPIO.


Acelerómetro
============
La pantalla viene por defecto configurada en modo vertical, para rotarla permanentemente el apaño implementado es ajustar el acelerómetro.
