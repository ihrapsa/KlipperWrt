# KlipperWrt
 ---------------------------------------------------------------------------------
 
 Klipper and fluidd/mainsail config files for OpenWrt embeded devices like the Creality Wi-Fi Box.
 
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
- A router box device released by Creality meant to add network control to your printer.  Big claims, lots of problems and frustrations. No desktop control, only mobile. No custom slicing only cloud based. No camera support, only claims.

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

### What is [OpenWrt](https://github.com/openwrt/openwrt)?
- A Linux OS built for embeded devices, routers especially. Light, Open Source with a great community and packages that gives your device the freedom it deserves. 
    
### What is [Klipper](https://github.com/KevinOConnor/klipper)?
- A 3d-printer firmware. It runs on any kind of computer taking advantage of the host cpu. Extremely light on cpu, lots of feautres

### What is [fluidd](https://github.com/cadriel/fluidd) / [mainsail](https://github.com/meteyou/mainsail)?
- These are free and open-source Klipper web interface clients for managing your 3d printer.
    
### What is [Moonraker](https://github.com/Arksine/moonraker)?
- A Python 3 based web server that exposes APIs with which client applications (fluidd or mainsail) may use to interact with Klipper

--------------------------------------------------------------------------

# Steps:
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

#### 3. Setup Wi-FI

<details>
  <summary>Click to expand!</summary>
 
* Edit `/etc/config/network`, `/etc/config/wireless` and `/etc/config/firewall`. I've uploaded these to follow as a model (inside `Wi-Fi`).

</details>

#### 4. Enable [extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) to expand the storage on the TF card.
<details>
  <summary>Click to expand!</summary>
  
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
  </details>
  
- **4.1 Enable swap just in case** (though the existing 128mb RAM seemed more than enough)
<details>
  <summary>Click to expand!</summary>

**run this once:**  
`opkg update && opkg install swap-utils`

`dd if=/dev/zero of=/overlay/swap.page bs=1M count=512`  
`mkswap /overlay/swap.page`  
`swapon /overlay/swap.page`  
`mount -o remount,size=200M /tmp`  
  
**put this inside /etc/rc.local above exit so that swap is enabled at boot:**  

###activate the swap file on the SD card  
`swapon /overlay/swap.page`  

###expand /tmp space  
`mount -o remount,size=200M /tmp`  
</details>

#### 5. Install dependencies

<details>
  <summary>Click to expand!</summary>
 
* for Klipper and moonraker - check the `requirements.txt` file
* Some of the packages like python2 (that refuse to be installed using `opkg` that aren't available inside `make menuconfig` either) can be installed by manually downloading and `scp` them to the box from the OpenWrt package repository for [`mipsel_24kc`](https://downloads.openwrt.org/releases/packages-19.07/mipsel_24kc/packages/) devices. (you need to find and download all the dependencies otherwise it won't let you install it) 

* :exclamation: An easier workaround I found was to use the v19.07 OpenWrt release feeds (this version still has python2 packages) for the same target (_ramips/mt76x8_) and cpu architecture (_mipsel_24kc_) as the box. I make a backup of the original `/etc/opkg/distfeeds.conf` and create another `distfeeds.conf`file with the v19.07 url feeds. Don't forget to run `opkg update` everytime you make modifications to that file. After finishing with installing the packages that are only available for the v19.07 and below (like python2 packages) I switch back to the backup `distfeeds.conf` file. 
* The `distfeeds.conf` file with openwrt v19.07 feeds should look something like this:
> src/gz openwrt_core http://downloads.openwrt.org/releases/19.07.7/targets/ramips/mt7621/packages   
src/gz openwrt_freifunk http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/freifunk  
src/gz openwrt_base http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/base  
src/gz openwrt_luci http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/luci  
src/gz openwrt_packages http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/packages  
src/gz openwrt_routing http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/routing  
src/gz openwrt_telephony http://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/telephony  

</details>

#### 6. Install Klipper

<details>
  <summary>Click to expand!</summary>
 
- **6.1 Clone Klipper inside** `~/`
- **6.2 Use provided klipper service and place inside `/etc/init.d/`**
- **6.3 Prepare your `printer.cfg` file**
           - do `mkdir ~/klipper_config`  and  `mkdir ~/gcode_files` . Locate your `.cfg` file inside `~/klipper/config/` copy it to `~/klipper_config` and rename it to `printer.cfg`
           - Add these lines inside `printer.cfg`:
           > 
           
           [virtual_sdcard]
           # for gcode upload
           path: ~/gcode_files

           [display_status]
           # for display messages in status panel

           [pause_resume]
           # for pause/resume functionality. 
           # Mainsail/fluidd needs gcode macros for `PAUSE`, `RESUME` and `CANCEL_PRINT` to make the buttons work.
           
           [gcode_macro PAUSE]
           rename_existing: BASE_PAUSE
           default_parameter_X: 230    #edit to your park position
           default_parameter_Y: 230    #edit to your park position
           default_parameter_Z: 10     #edit to your park position
           default_parameter_E: 1      #edit to your retract length
           gcode:
               SAVE_GCODE_STATE NAME=PAUSE_state
               BASE_PAUSE
               G91
               G1 E-{E} F2100
               G1 Z{Z}
               G90
               G1 X{X} Y{Y} F6000
               
           [gcode_macro RESUME]
           rename_existing: BASE_RESUME
           default_parameter_E: 1      #edit to your retract length
           gcode:
               G91
               G1 E{E} F2100
               G90
               RESTORE_GCODE_STATE NAME=PAUSE_state MOVE=1
               BASE_RESUME
               
           [gcode_macro CANCEL_PRINT]
           rename_existing: BASE_CANCEL_PRINT
           gcode:
               TURN_OFF_HEATERS
               CLEAR_PAUSE
               SDCARD_RESET_FILE
               BASE_CANCEL_PRINT
           
- **6.3 Build `klipper.bin` file**
            - Building is not mandatory to be done on the device that hosts klippy. To build it on the box you need a lot of dependencies that are not available for OpenWrt so I just used my pc running ubuntu - I used a custom baud: `230400` since the default `250000` did not work for me)
</details>
 
#### 7. Install moonraker + fluidd/mainsail
<details>
  <summary>Click to expand!</summary>
 
- **7.1 Follow mainsail Manual Setup [Guide](https://docs.mainsail.xyz/setup/manual-setup)** (it's almost identical for fluidd as well) - but avoid running any scripts (as those only work on debian/raspberry pi)
- **7.2 Use provided moonraker.conf file** You can find the `moonraker.conf` files in my repo: `/moonraker/*.conf`. Depending on your chosen client (`mainsail` or `fluidd`) rename the respective `.conf` file to `moonraker.conf`and put it in `~/klipper_config`. Note: The `[update_manager]` plugin was commented out since this is curently only supported for `debian` distros only. For now, updating `moonraker`, `klipper`, `fluidd` or `mainsail` should be done manaully.
- **7.3 Use provided moonraker service and place inside `/etc/init.d/`**
        - Don't forget to modify the `moonraker.conf` you copied inside `~/klipper_config` under `trusted_clients:` with your subnet.
- **7.4 Create and place all the nginx files inside `/etc/nginx/conf.d`***
* if you followed mainsail guide, `mainsail` should pe renamed to `mainsail.conf` and placed inside `/etc/nginx/conf.d/` alongside `common_vars.conf` and `upstreams.conf` (those 2 files are common for mainsail and fluidd)
* if you'd prefer fluidd, download the fluidd latest release instead of mainsail and use the `fluidd.conf` file instead of `mainsail.conf`.
* I've uploaded the `mainsail.conf` and `fluidd.conf` as well (look inside `nginx`). You need to use one or the other depending on your chosen client. Don't use both .conf files inside `/etc/nginx/conf.d/` or rename the unused client. Don't forget to create the `common_vars.conf` and `upstreams.conf` files as well.

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
 
#### 9. Enjoy 

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

- I didn't manage to get the printer to communicate on 250000 baudrate (I think because the box/pyserial is unable to set a custom nonstandard baudrate - I found a possible fix by [ckielstra](https://github.com/pyserial/pyserial/pull/496) but haven't tried it yet. I solved this by using 230400 instead (you need to change this both while building the mcu klipper firmware AND inside printer.cfg under [mcu]:  
`[mcu]`  
`baud: 230400`  

- The Host and Services commands (`Reboot`, `Shutdown`, `Restart Moonraker`, `Restart Klipper` etc.) inside fluidd/mainsail did not work at first due to moonraker using debian syntax. I solved this by editing the `~moonraker/moonraker/plugins/machine.py`. Use these commands inside `self._execute_cmd("command")`: `"poweroff"`, `"reboot"`, `f'/etc/init.d/{service_name} restart'` for host *poweroff*, *reboot* and *services restart* respectively.

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
* the fine tuning: andryblack - for the OpenWrt Klipper [service](https://github.com/andryblack/openwrt-build/tree/master/packages/klipper/files)
* the encouragement: [Tom Hensel](https://github.com/gretel)- for supporting me into this

--------------------------------------------------------------------------

You can find me on:  

💬 discord: jonah1024#4422  
:email: email: hrapsaiona@gmail.com  
