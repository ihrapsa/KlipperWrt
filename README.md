# KlipperWrt
 ---------------------------------------------------------------------------------
 
 A guide to get _**Klipper**_ with _**fluidd**,_ _**Mainsail**_ or _**Duet-Web-Control**_ on OpenWrt embeded devices like the _Creality Wi-Fi Box_.
 
 ---------------------------------------------------------------------------------
### Why Klipper on a Router :question:

<details>
  <summary> ( :red_circle: Click to expand!)</summary>
 
 - OpenWrt is so much more efficient than other linux distros.   
 - On a single core 580MHz cpu (with moonraker, klippy, nginx and mjpg-streamer) I get ~20-25% cpu load while idle/not printing and max 35-40% cpu load while printing and watching stream (640x480 30fps mjpeg). 

![alt text](https://github.com/ihrapsa/KlipperWrt/blob/main/screenshots/top_idle_moonraker_klippy_nginx_mjpg_streamer.png)
![alt text](https://github.com/ihrapsa/KlipperWrt/blob/main/screenshots/htop_idle.png)
![alt text](https://github.com/ihrapsa/KlipperWrt/blob/main/screenshots/test_print.png)  
![alt text](https://github.com/ihrapsa/KlipperWrt/blob/main/screenshots/stream.png)  
![alt text](https://github.com/ihrapsa/KlipperWrt/blob/main/screenshots/test_print.jpg)
  * I've tried octoprint on this box as well but unfortunately it was too resource intensive. Test prints speak for themselves.

</details>

### What is the Creality [Wi-Fi Box](https://www.creality.com/goods-detail/creality-box-3d-printer)?

<details>
  <summary>(Click to expand!)</summary>
 
[![creality_wb](img/creality_wb.jpg)](https://www.creality.com/goods-detail/creality-box-3d-printer)   
- A router box device released by Creality meant to add network control to your printer.  <br> Big claims, lots of problems and frustrations. No desktop control, only mobile. <br> No custom slicing only cloud based. No camera support, only claims.  

 <details>
   <summary>Specifications (Click to expand!)</summary>
 
 *(taken form figgyc's commit)*

- **SoC**: MediaTek MT7688AN @ 580 MHz  
- **Flash**: BoyaMicro BY25Q128AS (16 MiB, SPI NOR)  
- **RAM**: 128 MiB DDR2 (Winbond W971GG6SB-25)  
- **Peripheral**: Genesys Logic GL850G 2 port USB 2.0 hub  
- **I/O**: 1x 10/100 Ethernet port, microSD SD-XC Class 10 slot, 4x LEDs, 2x USB 2.0 ports, micro USB input (for power only), reset button  
- **FCC ID**: 2AXH6CREALITY-BOX  
- **UART**: test pads: (square on silkscreen) 3V3, TX, RX, GND; default baudrate: 57600  
 
   </details>
 </details>

### What is [OpenWrt](https://github.com/openwrt/openwrt)?

<details>
  <summary>(Click to expand!)</summary>
 
[![OpenWrt](img/OpenWrt.png)](https://openwrt.org)  

- A Linux OS built for embeded devices, routers especially. Light, Open Source  with a great community and <br> packages that gives your device the freedom it deserves.

 </details>
    
### What is [Klipper](https://github.com/KevinOConnor/klipper)?

<details>
  <summary>(Click to expand!)</summary>
 
[![Klipper](img/klipper.png)](https://www.klipper3d.org/)  

- A 3d-printer firmware. It runs on any kind of computer taking advantage of the host cpu. Extremely light on cpu, lots of feautres
</details>

### What is [fluidd](https://github.com/cadriel/fluidd) / [mainsail](https://github.com/meteyou/mainsail)?

<details>
  <summary>(Click to expand!)</summary>
 
[![fluidd](img/fluidd.png)](https://docs.fluidd.xyz)  [![mainsail](img/mainsail.png)](https://docs.mainsail.xyz)  
- These are free and open-source Klipper web interface clients for managing your 3d printer. 
</details>
 
### What is [Moonraker](https://github.com/Arksine/moonraker)?

<details>
  <summary>(Click to expand!)</summary>
 
[![Moonraker](img/moonraker.png)](https://moonraker.readthedocs.io/en/latest/)  
- A Python 3 based web server that exposes APIs with which client applications (fluidd or mainsail) may use to interact with Klipper. Communcation between the Klippy host and Moonraker is done over a Unix Domain Socket. Tornado is used to provide Moonraker's server functionality.
</details>

### What is [duet-web-control](https://github.com/Duet3D/DuetWebControl)


<details>
  <summary>(Click to expand!)</summary>
 
[![dwc](img/dwc.png)](https://duet3d.dozuki.com/Wiki/Duet_Web_Control_v2_and_v3_%28DWC%29_Manual)  
- Duet Web Control is a fully-responsive HTML5-based web interface for RepRapFirmware. [Stephan3](https://github.com/Stephan3/dwc2-for-klipper-socket) built a socket to make it communicate with klipper as well (klipper is not a RepRapFirmware). This is a standalone webserver and client interface - so no need for moonraker or nginx.
</details>

--------------------------------------------------------------------------
### :exclamation: Open issues or join the [<img align="center" width="30" height="30" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/discord.png" alt="discord_icon">](https://discord.gg/ZGrCMVs35H) [server](https://discord.gg/ZGrCMVs35H) for better support.
--------------------------------------------------------------------------

# Automatic Steps:

<details>
  <summary>Click to expand!</summary>

### Extroot script method 
Untarrs an laready working image.
Maybe outdated but stable.

<details>
  <summary>Click to expand!</summary>
  
This uses the preinstalled extroot filesystem archives I've uploaded to [Releases](https://github.com/ihrapsa/KlipperWrt/releases/tag/v1.0).  
They come preinstalled with either <img width="20" height="20" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/fluidd.png" alt="fluidd_icon"> **fluidd**  OR <img width="20" height="20" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/mainsail.png" alt="mainsail_icon"> **Mainsail** and **Klipper**, **Moonraker**, **mjpg-streamer** (for webcam stream) and Fry's **timelapse component** (for taking frames and rendering the video).
 
 
#### STEPS:
- Make sure you've flahsed/sysupgraded latest `.bin` file from `/Firmware/OpenWrt_snapshot/` or from latest release.
- Connect to the `KlipperWrt` access point
- Access LuCi web interface and log in on `192.168.1.1:81`
- _(**optional** but recommended)_ Add a password to the `KlipperWrt` access point: `Wireless` -> Under wireless overview `EDIT` the `KlipperWrt` interface -> `Wireless Security` -> Choose an encryption -> set a password -> `Save` -> `Save & Apply`
- _(**optional** but recommended)_ Add a password: `System` -> `Administration` -> `Router Password`
- Connect as a client to your Internet router: `Network` -> `Wireless` -> `SCAN` -> `Join Network` -> check `Lock to BSSID` -> `Create/Assign Firewall zone` then under `custom` type `wwan` enter -> `Submit` -> `Save` -> `Save & Apply`
- Connect back to your router and either find the new box's ip inside the `DHCP` list.
- ❗  Access the terminal tab (`Services` -> `Terminal`) ❗ If terminal tab is not working go to `Config` tab and change `Interface` to the interface you are connecting through the box (your wireless router SSID for example) -> `Save & Apply`.
- Download and execute the install script:

>
    cd ~
    wget https://github.com/ihrapsa/KlipperWrt/raw/main/KlipperWrt_install.sh
    chmod +x KlipperWrt_install.sh
    ./KlipperWrt_install.sh


- Follow the script prompts to install either `fluidd` or `Mainsail` automatically
- Wait until it prompts you to reboot
- remove the script when done: `rm -rf /root/*.sh`
- When done and rebooted use `http://klipperwrt.local` or `http://box-ip`to access the Klipper client
- Done!


#### Setting up your `printer.cfg`
- put your `printer.cfg` inside `/root/klipper_config`
- delete these blocks from your `printer.cfg`: `[virtual_sdcard]`, `[display_status]`, `[pause_resume]` since they're included inside `client.cfg`
- move all your macros to `client_macros.cfg` 
- add these 2 lines inside your `printer.cfg`:   
`[include client.cfg]`
`[include client_macros.cfg]` 
- Under `[mcu]` block change your serial port path according to [this](https://github.com/ihrapsa/KlipperWrt/issues/8)
- Build your `klippper.bin` mainboard firmware using a linux desktop/VM (follow `printer.cfg` header for instructions)
- Flash your mainboard according to the `printer.cfg` header
- Do a `FIRMWARE RESTART` inside fluidd/Minsail
- Done
_____________________________________________
*Notes:*
-  If the box doesn't connect back to your router wirelessly connect to it with an ethernet cable and setup/troubleshoot wifi.
- timelapse is set to autorender which might take a while to finish after a long print. You might set it to ` autorender: False`  under `[timelapse]` block inside `moonraker.conf`. Check [here](https://github.com/FrYakaTKoP/moonraker/blob/dev-timelapse/docs/configuration.md#add-the-macro-to-your-slicer) for how to set your `TIMELAPSE_TAKE_FRAME` macro or `TIMELAPSE_TAKE_PARKED_FRAME` inside your slicer layer change.
 
  </details>
  
### OR
  
### Installing Script method
Installes everything up to date
Possibly unstable, sometimes new dependencies are added and I might not have updated the script by then.

<details>
  <summary>Click to expand!</summary>

This method uses 2 scripts to foramt an sd card and make it extroot and another one that installes everything from the internet.

#### STEPS:
 
- Make sure you've flahsed/sysupgraded latest `.bin` file from `/Firmware/OpenWrt_snapshot/` or from latest release.
- Connect to the `KlipperWrt` access point
- Access LuCi web interface and log in on `192.168.1.1:81`
- _(**optional** but recommended)_ Add a password to the `KlipperWrt` access point: `Wireless` -> Under wireless overview `EDIT` the `KlipperWrt` interface -> `Wireless Security` -> Choose an encryption -> set a password -> `Save` -> `Save & Apply`
- _(**optional** but recommended)_ Add a password: `System` -> `Administration` -> `Router Password`
- Connect as a client to your Internet router: `Network` -> `Wireless` -> `SCAN` -> `Join Network` -> check `Lock to BSSID` -> `Create/Assign Firewall zone` then under `custom` type `wwan` enter -> `Submit` -> `Save` -> `Save & Apply`
- Connect back to your router and either find the new box's ip inside the `DHCP` list.
- ❗  Access the terminal tab (`Services` -> `Terminal`) ❗ If terminal tab is not working go to `Config` tab and change `Interface` to the interface you are connecting through the box (your wireless router SSID for example) -> `Save & Apply`.
- Download and execute the `1_format_extroot.sh` script:

>
    cd ~
    wget https://github.com/ihrapsa/KlipperWrt/raw/main/scripts/1_format_extroot.sh
    chmod +x 1_format_extroot.sh
    ./1_format_extroot.sh

- You'll be prompted to reboot: type `reboot`

- Download and execute the `2_script_manual.sh` script:

>
    cd ~
    wget https://github.com/ihrapsa/KlipperWrt/raw/main/scripts/2_script_manual.sh
    chmod +x 2_script_manual.sh
    ./2_script_manual.sh
    
- Follow the prompted instructions and wait for everything to be installed
- remove the scripts when done: `rm -rf /root/*.sh`
- Done!

- When done and rebooted use `http://klipperwrt.local` or `http://box-ip`to access the Klipper client
- Done!


#### Setting up your `printer.cfg`
- put your `printer.cfg` inside `/root/klipper_config`
- delete these blocks from your `printer.cfg`: `[virtual_sdcard]`, `[display_status]`, `[pause_resume]` since they're included inside `client.cfg`
- move all your macros to `client_macros.cfg` 
- add these 2 lines inside your `printer.cfg`:   
`[include client.cfg]`
`[include client_macros.cfg]` 
- Under `[mcu]` block change your serial port path according to [this](https://github.com/ihrapsa/KlipperWrt/issues/8)
- Build your `klippper.bin` mainboard firmware using a linux desktop/VM (follow `printer.cfg` header for instructions)
- Flash your mainboard according to the `printer.cfg` header
- Do a `FIRMWARE RESTART` inside fluidd/Minsail
- Done
_____________________________________________
*Notes:*
-  If the box doesn't connect back to your router wirelessly connect to it with an ethernet cable and setup/troubleshoot wifi.
- timelapse is set to autorender which might take a while to finish after a long print. You might set it to ` autorender: False`  under `[timelapse]` block inside `moonraker.conf`. Check [here](https://github.com/FrYakaTKoP/moonraker/blob/dev-timelapse/docs/configuration.md#add-the-macro-to-your-slicer) for how to set your `TIMELAPSE_TAKE_FRAME` macro or `TIMELAPSE_TAKE_PARKED_FRAME` inside your slicer layer change.

</details>

</details>

# Manual Steps:

### OpenWrt <img align="left" width="30" height="34" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/OpenWrt.png" alt="openwrt_icon">

<details>
  <summary>Click to expand Steps!</summary>

#### 1. Build OpenWrt image

<details>
  <summary>Click to expand!</summary>
 
* Only neccesary until the [port](https://github.com/openwrt/openwrt/pull/3802) gets merged and officially supported.
  * I recommend following figgyc's [post](https://github.com/figgyc/figgyc.github.io/blob/source/posts.org#compiling-openwrt-for-the-creality-wb-01-tips-and-tricks). You'll find there his experience and a guide to compile OpenWrt. Here is his OpenWrt [branch](https://github.com/figgyc/openwrt/tree/wb01) with support for the Creality Wi-Fi Box and the [PR](https://github.com/openwrt/openwrt/pull/3802) pending to merge to main OpenWrt.
  
  * :exclamation: This is an OpenWrt snapshot (aka not officially supported) and kernel modules can't be installed with opkg. You NEED to choose some required kmods inside `make menuconfig`:  
  `kmod-fs-ext4` `kmod-usb-storage` `kmod-usb-ohci` `kmod-usb-uhci` `kmod-usb-serial` `kmod-usb-serial-ch341`*  `kmod-video-core` `kmod-video-uvc`  
  *(chose this because my printer has the ch341 serial usb convertor. You might want to choose `kmod-usb-serial-fttdi` if your mainboard uses that - check this before building/compiling) 
  
  **OR use the provided image I built located inside `Firmware/OpenWrt_snapshot` - Be aware though  that this was built with only the `kmod-usb-serial-ch431` - if your mainboard is different -> use the above instructions to compile.**
  
  </details>
#### 2. Install OpenWrt to the device

<details>
  <summary>Click to expand!</summary>
 
Flashing:  
1) Rename factory.bin to cxsw_update.tar.bz2  
2) Copy it to the root of a FAT32 formatted microSD card.  
3) Turn on the device, wait for it to start, then insert the card. The stock firmware reads the install.sh script from this archive, the build script I added creates one that works in a similar way. Web firmware update didn't work in my testing.

</details>

#### 3. Setup Wi-Fi

<details>
  <summary>Click to expand!</summary>
 
* If the flashing was successful you should be able to ssh to the box through ethernet. Plug it in your PC (prefered way) or router and do `ssh root@192.168.1.1` in `Windows PowerShell` or any `unix terminal` or use `putty`.  
* Edit `/etc/config/network`, `/etc/config/wireless` and `/etc/config/firewall`. I've uploaded these to follow as a model (inside `Wi-Fi`).
* Use `iw dev wlan0 scan` to scan for near wi-fi networks and look for the bssid specific to your 2.4Ghz SSID.

</details>

#### 4. Enable [extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) _(to expand the storage on the TF card)_ and enable swap.

<details>
     <summary>Click to expand!</summary>
 

- **Extroot**

`opkg update && opkg install block-mount kmod-fs-ext4 kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk`  
`DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)"`  
`uci -q delete fstab.rwm`  
`uci set fstab.rwm="mount"`  
`uci set fstab.rwm.device="${DEVICE}"`  
`uci set fstab.rwm.target="/rwm"`  
`uci commit fstab`  

`mkfs.ext4 /dev/mmcblk0p1`  

`DEVICE="/dev/mmcblk0p1"`  
`eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*")`  
`uci -q delete fstab.overlay`  
`uci set fstab.overlay="mount"`  
`uci set fstab.overlay.uuid="${UUID}"`  
`uci set fstab.overlay.target="/overlay"`  
`uci commit fstab`  
`mount /dev/mmcblk0p1 /mnt`  
`cp -f -a /overlay/. /mnt`  
`umount /mnt`  
`reboot`  


- **swap** (though the existing 128mb RAM seemed more than enough)

run this once:  

>

    opkg update && opkg install swap-utils

    dd if=/dev/zero of=/overlay/swap.page bs=1M count=512
    mkswap /overlay/swap.page 
    swapon /overlay/swap.page
    mount -o remount,size=256M /tmp 

put this inside /etc/rc.local above exit so that swap is enabled at boot:  

>

    ###activate the swap file on the SD card  
    swapon /overlay/swap.page  

    ###expand /tmp space  
    mount -o remount,size=256M /tmp  

</details>

</details>


### fluidd <img align="left" width="30" height="30" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/fluidd.png" alt="fluidd_icon"> / <img width="30" height="30" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/mainsail.png" alt="mainsail_icon"> Mainsail 

<details>
  <summary>Click to expand!</summary>
 
#### 5. Install dependencies

<details>
  <summary>Click to expand!</summary>
 
* for Klipper and moonraker - check the `requirements` folder. 
* Install`git-http` with `opkg update && opkg install git-http gcc unzip htop`
* :exclamation: Python2 packages are not available by default for this `snapshot` A workaround I found was to use the v19.07 OpenWrt release feeds (this version still has python2 packages) for the same target (_ramips/mt76x8_) and cpu architecture (_mipsel_24kc_) as the box. I make a backup of the original `/etc/opkg/distfeeds.conf` and create another `distfeeds.conf`file with the v19.07 url feeds. Don't forget to run `opkg update` everytime you make modifications to that file. After finishing with installing the packages that are only available for the v19.07 and below (like python2 packages) I switch back to the backup `distfeeds.conf` file. 

* The `distfeeds.conf` file with openwrt v19.07 feeds should look something like this:

 >

	src/gz openwrt_core https://downloads.openwrt.org/releases/19.07.7/targets/ramips/mt76x8/packages
	src/gz openwrt_base https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/base
	src/gz openwrt_luci https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/luci
	src/gz openwrt_packages https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/packages
	src/gz openwrt_routing https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/routing
	src/gz openwrt_telephony https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/telephony  

 * Do `opkg update`  
 :exclamation: If you get `wrong signature` errors, comment the `option check_signature` line under `/etc/opkg.conf` - you can uncomment this after finishing with `v19.07 distfeeds`  
* After you add the v19.07 `distfeeds.conf` -> install python2 packages:

 >
 
    opkg install python python-pip python-cffi python-dev
* Install `250k` baud `pyserial`:

>
	cd ~
	git clone https://github.com/ihrapsa/pyserial
	cd pyserial
	python setup.py install
	rm -rf /root/pyserial
	
<details>
  <summary>Note!</summary>	
	
_ The official `pyserial` python package is not configured to work with `250000 baud` on `MIPS` platforms (only `230400` max). Luckly someone fixed that in a fork and used his work to bring the [repo](https://github.com/ihrapsa/pyserial.git) up to date_
	
</details>
	
 >
    pip install greenlet==0.4.15 jinja2 python-can==3.3.4  
 
* :exclamation: **Switch back to original `distfeeds.conf`, `opkg update` -> install python3 and packages:** 
 >            
 
    opkg install python3 python3-pip python3-pyserial python3-pillow python3-tornado python3-distro libsodium --force-overwrite 
    
* Update `setuptools`package to latest version otherwise `inotify-simple` will fail installing.	
 
 >
    cd ~
    git clone https://github.com/pypa/setuptools.git
    cd setuptools
    python3 setup.py install
    rm -rf /root/setuptools
	
    pip3 install inotify-simple python-jose libnacl paho-mqtt==1.5.1

*Install `lmdb` and `streaming-form-data` 

<details>
  <summary>Note!</summary>
	
_Those can be found inside `Packages` as a single `*ipk` file. I cross-compiled them while building the OpenWrt image as I couldn't install it with `pip` (they need gcc>=8.4 which is not available for OpenWrt yet)._
	
</details>
	
>

	cd ~
	wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/python3-lmdb%2Bstreaming-form-data_packages_1.0-1_mipsel_24kc.ipk
	opkg install python3-lmdb%2Bstreaming-form-data_packages_1.0-1_mipsel_24kc.ipk

* Install nginx with `opkg install nginx-ssl`


</details>

#### 6. Install Klipper

<details>
  <summary>Click to expand!</summary>
 
- **6.1 Clone Klipper inside** `~/`  
           - `git clone https://github.com/KevinOConnor/klipper.git`. 
- **6.2 Use provided klipper service and place inside `/etc/init.d/`**
	
>
	wget -q -O /etc/init.d/klipper https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/Services/klipper
	chmod 755 /etc/init.d/klipper

- **6.3 Enable klipper service:** 
	
>
	/etc/init.d/klipper enable
	
- **6.4 Prepare your `printer.cfg` file:**
	
>	
	mkdir ~/klipper_config ~/klipper_logs ~/gcode_files
	
	
- Locate your `.cfg` file inside `~/klipper/config/` copy it to `~/klipper_config` and rename it to `printer.cfg`
	
- Inside `printer.cfg` under `[mcu]` replace  serial line with `serial: /dev/ttyUSB0`
- Add these lines at the end of the file:
	
>

    [virtual_sdcard]
    # for gcode upload
    path: /root/gcode_files

    [display_status]
    # for display messages in status panel

    [pause_resume]
    # for pause/resume functionality. 
    # Mainsail/fluidd needs gcode macros for `PAUSE`, `RESUME` and `CANCEL_PRINT` to make the buttons work.

	[gcode_macro CANCEL_PRINT]
	description: Cancel the actual running print
	rename_existing: CANCEL_PRINT_BASE
	gcode:
		TURN_OFF_HEATERS
		CANCEL_PRINT_BASE

	[gcode_macro PAUSE]
	description: Pause the actual running print
	rename_existing: PAUSE_BASE
	# change this if you need more or less extrusion
	variable_extrude: 1.0
	gcode:
		##### read E from pause macro #####
		{% set E = printer["gcode_macro PAUSE"].extrude|float %}
		##### set park positon for x and y #####
		# default is your max posion from your printer.cfg
		{% set x_park = printer.toolhead.axis_maximum.x|float - 5.0 %}
		{% set y_park = printer.toolhead.axis_maximum.y|float - 5.0 %}
		##### calculate save lift position #####
		{% set max_z = printer.toolhead.axis_maximum.z|float %}
		{% set act_z = printer.toolhead.position.z|float %}
		{% if act_z < (max_z - 2.0) %}
			{% set z_safe = 2.0 %}
		{% else %}
			{% set z_safe = max_z - act_z %}
		{% endif %}
		##### end of definitions #####
		PAUSE_BASE
		G91
		{% if printer.extruder.can_extrude|lower == 'true' %}
		  G1 E-{E} F2100
		{% else %}
		  {action_respond_info("Extruder not hot enough")}
		{% endif %}
		{% if "xyz" in printer.toolhead.homed_axes %}
		  G1 Z{z_safe} F900
		  G90
		  G1 X{x_park} Y{y_park} F6000
		{% else %}
		  {action_respond_info("Printer not homed")}
		{% endif %} 
		
	[gcode_macro RESUME]
	description: Resume the actual running print
	rename_existing: RESUME_BASE
	gcode:
		##### read E from pause macro #####
		{% set E = printer["gcode_macro PAUSE"].extrude|float %}
		#### get VELOCITY parameter if specified ####
		{% if 'VELOCITY' in params|upper %}
		  {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}
		{%else %}
		  {% set get_params = "" %}
		{% endif %}
		##### end of definitions #####
		{% if printer.extruder.can_extrude|lower == 'true' %}
		  G91
		  G1 E{E} F2100
		{% else %}
		  {action_respond_info("Extruder not hot enough")}
		{% endif %}  
		RESUME_BASE {get_params}

           
- **6.5 Restart klipper** - do `service klipper restart` or `/etc/init.d/klipper restart`
- **6.6 Build `klipper.bin` file**  
            - Building is not mandatory to be done on the device that hosts klippy. To build it on this box you would need a lot of dependencies that are not available for OpenWrt so I just used my pc running ubuntu: On a different computer running linux (or VM or live USB) -> Clone klipper just like you did before -> `cd klipper` -> `make menuconfig` -> use the configurations specific to your mainboard (Check the header inside your `printer.cfg` file for details).  
:exclamation: use custom baud: `230400`. By default 250000 is selected. If you want/need that baud, remove the `python-pyserial` package and install this version of [pyserial](https://github.com/ihrapsa/pyserial) instead - check `Requirements` directory for details about installation process.    
-> once configured run `make` -> if succesfull the firmware will be inside `./out/klipper.bin` -> flash the mainboard:(check header of `printer.cfg` again - some mainboards need the `.bin` file renamed a certain way) copy the `.bin` file on a sd card -> plug the card with the printer off -> turn printer on and wait a minute -> Done (Depending on your mainboard/printer/lcd you will probably not have a sign that the mainboard got flashed so don't worry) - if at the end of this guide the client cannot connect to the klipper firmware usually the problem is with the `.bin` file building or flashing process.
</details> 
 
#### 7. Install moonraker + fluidd/mainsail
<details>
  <summary>Click to expand!</summary>
 
- **7.1 Clone Moonraker** 
>
    cd ~
    git clone https://github.com/Arksine/moonraker.git

- **7.2 Use provided moonraker.conf file and download chosen client**   
	
**For fluidd:**

>
	mkdir ~/fluidd
	wget -q -O /root/fluidd/fluidd.zip https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip && unzip /root/fluidd/fluidd.zip -d /root/fluidd/ && rm /root/fluidd/fluidd.zip
	wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/fluidd_moonraker.conf 
	wget -q -O /etc/nginx/conf.d/fluidd.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/fluidd.conf
	

**For Mainsail:**

>
	mkdir ~/mainsail
	wget -q -O /root/mainsail/mainsail.zip https://github.com/meteyou/mainsail/releases/latest/download/mainsail.zip && unzip /root/mainsail/mainsail.zip -d /root/mainsail/ && rm /root/mainsail/mainsail.zip
	wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/mainsail_moonraker.conf 
	wget -q -O /etc/nginx/conf.d/mainsail.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/mainsail.conf
	
Note: _The `[update_manager]` plugin was commented out since this is curently only supported for `debian` distros only. For now, updating `moonraker`, `klipper`, `fluidd` or `mainsail` should be done manaully._  
	
Don't forget to edit(if necessary) the `moonraker.conf` file you copied inside `~/klipper_config` under `trusted_clients:` with your client ip or ip range (_client meaning the device you want to access fluidd/mainsail from_). Check the moonraker [configuration](https://github.com/Arksine/moonraker/blob/master/docs/configuration.md#authorization) doc for details.
- **7.3 Use provided moonraker service and place inside `/etc/init.d/`** 

>
	wget -q -O /etc/init.d/moonraker https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/Services/moonraker
	chmod 755 /etc/init.d/moonraker
	/etc/init.d/moonraker enable
	/etc/init.d/moonraker restart 
	
- **7.4 Download the rest of the nginx files inside `/etc/nginx/conf.d`***  
 
>
	wget -q -O /etc/nginx/conf.d/upstreams.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/upstreams.conf
	wget -q -O /etc/nginx/conf.d/common_vars.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/common_vars.conf
	
 Inside `/etc/nginx/conf.d`you should have `fluidd.conf` OR `mainsail.conf` alongside `common_vars.conf` AND `upstreams.conf` (those 2 files are common for mainsail and fluidd)  
**Note!**  
You need to use either `fluidd.conf` or `mainsail.conf` file depending on your chosen client. Don't use both `.conf` files inside `/etc/nginx/conf.d/`. If you want to test both clients and easly switch between them check the **! How to switch between fluidd and mainsail:** below.


**Note!**  
It's ok to keep both client directories inside `/root/` as these are static files. Careful with the `.conf` file inside `/etc/nginx/conf.d`.
	
- **7.6 Restart nginx** with `service nginx restart` and check browser if `http://your-ip` brings you the client interface (fluidd or mainsail).

:exclamation: **How to switch between fluidd and mainsail:**
   1. switch between `mainsail.conf`and `fluidd.conf` file inside `/etc/nginx/conf.d` (make sure the other one gets renamed to a different `extension`. eg: `*.conf_off` or moved to a different fodler.)
   2. Switch between mainsail and fluidd `moonraker.conf` files inside `~/klipper_config`. Find them inside my repo under `moonraker` directory. 
   3. Restart moonraker and nginx services: `service moonraker restart` and `service nginx restart`
</details>
 
 
#### 8. Install mjpg-streamer - for webcam stream

<details>
  <summary>Click to expand!</summary>
 
* install video4linux utilities: `opkg update && opkg install v4l-utils`
* use commands: `opkg update && opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www`
* connect a uvc webcam, configure `/etc/config/mjpg-streamer` to your likings, enable and restart service: 
>`/etc/init.d/mjpg-streamer enable`  
`/etc/init.d/mjpg-streamer restart`
* put the stream link inside the client(fluidd/mainsail) camera setting: `http://<your_ip>/webcam/?action=stream`

</details>
 
 #### 9. (Optional) Use hostname instead of ip

<details>
  <summary>Click to expand!</summary>
 
* To change your hostname go to `/etc/config/system` and modify `option hostname 'OpenWrt'` to your likings.
* To use your hostname in browser and ssh instead of the ip do:
> 

    opkg update
    opkg install avahi-daemon-service-ssh avahi-daemon-service-http
    reboot
* Instead of `http://your-ip` use `http://your_hostname.local`
</details>
 
#### 10. Enjoy

</details>


### duet-web-control <img align="left" width="30" height="30" src="https://github.com/ihrapsa/KlipperWrt/blob/main/img/dwc.png" alt="dwc_icon"> 

<details>
  <summary>Click to expand!</summary>

#### 5. Install dependencies

<details>
  <summary>Click to expand!</summary>
 
* for Klipper - check the `requirements.txt` file. 

* :exclamation: Python2 packages are not available by default for this `snapshot` A workaround I found was to use the v19.07 OpenWrt release feeds (this version still has python2 packages) for the same target (_ramips/mt76x8_) and cpu architecture (_mipsel_24kc_) as the box. I make a backup of the original `/etc/opkg/distfeeds.conf` and create another `distfeeds.conf`file with the v19.07 url feeds. Don't forget to run `opkg update` everytime you make modifications to that file. After finishing with installing the packages that are only available for the v19.07 and below (like python2 packages) I switch back to the backup `distfeeds.conf` file. 

* The `distfeeds.conf` file with openwrt v19.07 feeds should look something like this:
> 

	src/gz openwrt_core https://downloads.openwrt.org/releases/19.07.7/targets/ramips/mt76x8/packages
	src/gz openwrt_base https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/base
	src/gz openwrt_luci https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/luci
	src/gz openwrt_packages https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/packages
	src/gz openwrt_routing https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/routing
	src/gz openwrt_telephony https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/telephony  

* Do `opkg update`  
 :exclamation: If you get `wrong signature` errors, comment the `option check_signature` line under `/etc/opkg.conf` - you can uncomment this after finishing with `v19.07 distfeeds`  
* After you add the v19.07 `distfeeds.conf` -> install python2 packages: with `opkg install python python-pip python-cffi python-pyserial python-dev gcc`.   
 :exclamation: __The official `pyserial` python package is not configured to work with `250000 baud` on `MIPS` platforms (only `230400` max). If you want/need 250k baud, install this version of [pyserial](https://github.com/ihrapsa/pyserial) and install it with `python2 setup.py install`__  
* With pip install: `pip install greenlet==0.4.15 jinja2 python-can=3.3.4`  
* Switch back to original `distfeeds.conf`, `opkg update` -> install python3 and packages: `opkg install python3 python3-pip python3-tornado`.
 
 </details>

#### 6. Install Klipper

<details>
  <summary>Click to expand!</summary>
 
- **6.1 Clone Klipper inside** `~/`  
           - do `opkg install git-http unzip` then  `git clone https://github.com/KevinOConnor/klipper.git`. 
- **6.2 Use provided klipper service and place inside `/etc/init.d/`**  - find it inside `Services -> klipper`
- **6.3 Enable klipper service:** Everytime you create a service file you need to give it executable permissions before enabling it. For klipper do `chmod 755 klipper`. You can enable it now by `/etc/init.d/klipper enable`
- **6.4 Prepare your `printer.cfg` file**
           - do `mkdir ~/klipper_config`  and  `mkdir ~/gcode_files` . Locate your `.cfg` file inside `~/klipper/config/` copy it to `~/klipper_config` and rename it to `printer.cfg`
           - Inside `printer.cfg` under `[mcu]` replace  serial line with `serial: /dev/ttyUSB0` and add a new line: `baud: 230400` - (check requirements if you want/need 250000 baud)  
- **6.5 Restart klipper** - do `service klipper restart` or `/etc/init.d/klipper restart`
- **6.6 Build `klipper.bin` file**
            - Building is not mandatory to be done on the device that hosts klippy. To build it on this box you would need a lot of dependencies that are not available for OpenWrt so I just used my pc running ubuntu: On a different computer running linux (or VM or live USB) -> Clone klipper just like you did before -> `cd klipper` -> `make menuconfig` -> use the configurations specific to your mainboard (Check the header inside your `printer.cfg` file for details).  
:exclamation: use custom baud: `230400`. By default 250000 is selected. If you want/need that baud, remove the `python-pyserial` package and install this version of [pyserial](https://github.com/ihrapsa/pyserial.git) instead - check `Requirements` directory for details about installation process.
-> once configured run `make` -> if succesfull the firmware will be inside `./out/klipper.bin` -> flash the mainboard:(check header of `printer.cfg` again - some mainboards need the `.bin` file renamed a certain way) copy the `.bin` file on a sd card -> plug the card with the printer off -> turn printer on and wait a minute -> Done (Depending on your mainboard/printer/lcd you will probably not have a sign that the mainboard got flashed so don't worry) - if at the end of this guide the client cannot connect to the klipper firmware usually the problem is with the `.bin` file building or flashing process.

</details>

#### 7. Get dwc socket for klipper

<details>
  <summary>Click to expand!</summary>

* **Download**  
`cd ~`  
`git clone https://github.com/Stephan3/dwc2-for-klipper-socket`  

* **Edit `dwc2.cfg`** - set the `web_root:` path to absolute path: `/root/sdcard/web`

* **Create dwc socket service**  
Create a `dwc` file inside `/etc/init.d/` with the contents of the `dwc` file inside my repo: `Services->dwc`  
Give it executable permissions: `chmod 755 /etc/init.s/dwc`  
Enable it: `/etc/init.d/dwc enable`  

</details>

#### 8. Get dwc

<details>
  <summary>Click to expand!</summary>
 
 * Download dwc version 3 web interface  

>

    mkdir -p ~/sdcard/web
    cd ~/sdcard/web
    wget -O DuetWebControl-SD.zip https://github.com/Duet3D/DuetWebControl/releases/download/3.1.1/DuetWebControl-SD.zip
    unzip *.zip && for f_ in $(find . | grep '.gz');do gunzip ${f_};done
    rm DuetWebControl-SD.zip

 
 * Restart dwc socket service: `service dwc restart` or `/etc/init.d/dwc restart`  
 * Test: `https:://<your_ip>:4750`
 
</details>

#### 9. (Optional) Use hostname instead of ip

<details>
  <summary>Click to expand!</summary>
 
* To change your hostname go to `/etc/config/system` and modify `option hostname 'OpenWrt'` to your likings.
* To use your hostname in browser and ssh instead of the ip do:
> 

    opkg update
    opkg install avahi-daemon-service-ssh avahi-daemon-service-http
    reboot
* Instead of `http://your-ip` use `http://your_hostname.local`
</details>

#### 10. Enjoy

</details>



--------------------------------------------------------------------------
#### Troubleshooting

<details>
  <summary>Click to expand!</summary>

* Open a separate `ssh` instance and run `logread -f` - you'll get real time log data of the running process.  
* You can always open an issue or contact me if you get stuck or something doesn't work.  

</details>

--------------------------------------------------------------------------
#### :computer: Useful commands

<details>
  <summary>Click to expand!</summary>
 
 - Creating a non-privileged user  
  Check this [guide](https://openwrt.org/docs/guide-user/security/secure.access#create_a_non-privileged_user_in_openwrt)
     *All the tests I did were as root* - some modifications would be necessary to not run everything as root.  
    - Packages needed: `shadow-useradd` , `sudo`, `shadow-groupadd`, `shadow-usermod`

- Copy files to the box 
`scp /path/file.ext root@<your_box_ip>:/tmp`  

- Watch realtime CommandLine log (open an aditional terminal instance for this)  
`logread -f`  

- Services commands (Replace `service` with `klipper`/`moonraker`/`nginx`/`mjpg-streamer` respectively)  
`/etc/init.d/service enable`  
`/etc/init.d/service start`  
`/etc/init.d/service restart`  

- Check CPU/system resources usage  
`top`

- Check webcam specifcations  
`v4l2-ctl --all`  
`v4l2-ctl --list-formats`  

- List installed packages  
`opkg list-installed`

- Reboot, Poweroff  
`reboot`  
`poweroff`

</details>

--------------------------------------------------------------------------

#### :exclamation: Issues I had but solved:

<details>
  <summary>Click to expand!</summary>
 
- If enabling the services returns an error, do: `ls -l` inside `/etc/init.d/` and check if the service has executable permissions (x flag). If not do: `chmod 755 service` - replace `service` accordingly.

- I didn't manage to get the printer to communicate on 250000 baudrate (Official version of pyserial is unable to set a custom nonstandard baudrate - I found a fix by [ckielstra](https://github.com/pyserial/pyserial/pull/496) in a PR that is not yet merged. I've added his changes to my [forked](https://github.com/ihrapsa/pyserial) pyserial as well which is updated more often. If you don't want to use 250k baudrate I solved this issue by using 230400 instead (you need to change this both while building the mcu klipper firmware AND inside printer.cfg under [mcu]:  
`[mcu]`  
`baud: 230400`  

- The Host and Services commands (`Reboot`, `Shutdown`, `Restart Moonraker`, `Restart Klipper` etc.) inside fluidd/mainsail did not work at first due to moonraker using debian syntax. I solved this by editing the `~moonraker/moonraker/components/machine.py`. Use these commands inside `self._execute_cmd("command")`: `"poweroff"`, `"reboot"`, `f'/etc/init.d/{service_name} restart'` for host *poweroff*, *reboot* and *services restart* respectively.

</details>

--------------------------------------------------------------------------
### :warning:  Going back to stock (if ever needed) OR if it gets bricked:

<details>
  <summary>Click to expand!</summary>
 
1. Download a [stock](http://file2-cdn.creality.com/model/cfg/box/V1.01b51/cxsw_update.tar.bz2) image (found inside `Firmware/Creality_Stock` folder as well) or get a previowsly working OpenWrt image.
2. Unzip the stock `tar.bz2` and get the `root_uImage` file OR if you have a previously working OpenWrt image: rename it to `root_uImage`
3. Put it on a FAT32 formatted USB stick (NOT sd card)
4. Insert it in the box while off
5. Press and hold the reset button
6. Power on the box while still holding the reset button for about 6-10 sec.
7. Release the button and wait for a couple of minutes. If stock, you should find it on network. If OpenWrt you should be able to ssh into it through ethernet(`ssh root@192.168.1.1`)

</details>

--------------------------------------------------------------------------
### Credits:
* the ideea: Hackaday.com - for the [article](https://hackaday.com/2020/12/28/teardown-creality-wifi-box) that set me on this journey
* the hard part: figgyc - for porting [OpenWrt](https://github.com/figgyc/openwrt/tree/wb01) to the Creality Wi-Fi Box
* the essentials: 
  - Kevin O'Connor - for [Klipper](https://github.com/KevinOConnor/klipper)
  - cadriel - for [fluidd](https://github.com/cadriel/fluidd)
  - mateyou - for [mainsail](https://github.com/meteyou/mainsail)  
  - Eric Callahan - for [Moonraker](https://github.com/Arksine/moonraker)
  - Stephan3 - for [dwc socket](https://github.com/Stephan3/dwc2-for-klipper-socket)
  - Duet3D - for [DuetWebControl](https://github.com/Duet3D/DuetWebControl)
* the fine tuning: andryblack - for the OpenWrt Klipper [service](https://github.com/andryblack/openwrt-build/tree/master/packages/klipper/files)
* the encouragement: [Tom Hensel](https://github.com/gretel)- for supporting me into this

--------------------------------------------------------------------------

You can find me on:  

💬 discord: jonah1024#4422  or join the [server](https://discord.gg/ZGrCMVs35H)  
:email: email: hrapsaiona@gmail.com  
