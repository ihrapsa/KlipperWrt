# KlipperWrt
 Klipper and fluidd/mainsail config files for OpenWrt embeded devices like the Creality Wi-Fi Box.

### What is the Creality [Wi-Fi Box](https://www.creality.com/goods-detail/creality-box-3d-printer)?
- A router box device released by Creality meant to add network control to your printer.  Big claims, lots of problems and frustrations. No desktop control, only mobile. No custom slicing only cloud based. No camera support, only claims.

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
* Only neccesary until the [port](https://github.com/openwrt/openwrt/pull/3802) gets merged and officially supported.
  * I recommend following figgyc's [post](https://github.com/figgyc/figgyc.github.io/blob/source/posts.org#compiling-openwrt-for-the-creality-wb-01-tips-and-tricks). You'll find there his experience and a guide to compile OpenWrt. Here is his OpenWrt [branch](https://github.com/figgyc/openwrt/tree/wb01) with support for the Creality Wi-Fi Box and the [PR](https://github.com/openwrt/openwrt/pull/3802) pending to merge to main OpenWrt.
#### 2. Install OpenWrt to the device

<details>
  <summary>Click to expand!</summary>
 
Flashing:  
1) Rename factory.bin to cxsw_update.tar.bz2  
2) Copy it to the root of a FAT32 formatted microSD card.  
3) Turn on the device, wait for it to start, then insert the card. The stock firmware reads the install.sh script from this archive, the build script I added creates one that works in a similar way. Web firmware update didn't work in my testing.

</details>

#### 3. Setup Wi-FI
* Edit `/etc/config/network`, `/etc/config/wireless` and `/etc/config/firewall`. I've uploaded these to follow as a model.
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
* for Klipper and moonraker/fluidd/mainsail - check the `requirements.txt` file
#### 6. Install Klipper
- **6.1 Clone Klipper inside `~/`
- **6.1 Use provided klipper service and place inside `/etc/init.d/`**
#### 7. Install fluidd/mainsail
- **7.1 Follow mainsail Manual Setup [Guide](https://docs.mainsail.xyz/setup/manual-setup)** (it's almost identical for fluidd as well)
- **7.2 Use provided moonraker service and place inside `/etc/init.d/`**
        - Don't forget to modify the `moonraker.conf` you created inside `~/klipper_config` under `trusted_clients:` with your subnet.
- **7.3 Create and place all the nginx files inside `/etc/nginx/conf.d`***
* if you followed mainsail guide, `mainsail` should pe renamed to `mainsail.conf` and placed inside `/etc/nginx/conf.d/` alongside `common_vars.conf` and `upstreams.conf`
* if you'd prefer fluidd, download the fluidd latest release instead of mainsail and use the `fluidd.conf` file instead of `mainsail.conf`.
* I've uploaded the `mainsail.conf` and `fluidd.conf` as well. You need to use one or the other depending on your chosen client. Don't use both .conf files inside `/etc/nginx/conf.d/` or rename the unused client.
#### 8. Install mjpg-streamer - for webcam stream
* use commands: `opkg update && opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www`
* connect a uvc webcam, configure `/etc/config/mjpg-streamer` to your likings and restart service `/etc/init.d/mjpg-streeamer restart`
* put the stream link inside the client(fluidd/mainsail) camera setting: `http://<your_ip>/webcam/?action=stream`
#### 9. Enjoy 

--------------------------------------------------------------------------

#### Issues I had but solved:
- I didn't manage to get the printer to communicate on 250000 baudrate (I think because the box/pyserial is unable to set a custom nonstandard baudrate - I found a possible fix by [ckielstra](https://github.com/pyserial/pyserial/pull/496) but haven't tried it yet. I solved this by using 230400 instead (you need to change this both while building the mcu klipper firmware AND inside printer.cfg under [mcu]:  
`[mcu]`  
`baud: 230400`  

- The Host and Services commands (`Reboot`, `Shutdown`, `Restart Moonraker`, `Restart Klipper` etc.) inside fluidd/mainsail did not work at first due to moonraker using debian syntax. I solved this by editing the `~moonraker/moonraker/plugins/machine.py`. Use these commands inside `self._execute_cmd("command")`: `"poweroff"`, `"reboot"`, `f'/etc/init.d/{service_name} restart'` for host *poweroff*, *reboot* and *services restart* respectively.
- 
--------------------------------------------------------------------------
### :warning:  Going back to stock (if ever needed) OR if it gets bricked:
1. Download a [stock](http://file2-cdn.creality.com/model/cfg/box/V1.01b51/cxsw_update.tar.bz2) image (found inside Stock_fw folder as well) or get a previowsly working OpenWrt image.
2. Unzip the stock `tar.bz2` and get the `root_uImage` file OR if you have a previously working OpenWrt image: rename it to `root_uImage`
3. Put it on a FAT32 formatted USB stick (NOT sd card)
4. Insert it in the box while off
5. Press and hold the reset button
6. Power on the box while still holding the reset button for about 6-10 sec.
7. Release the button and wait for a couple of minutes. If stock, you should find it on network. If OpenWrt you should be able to ssh into it through ethernet(`ssh root@192.168.1.1`)
--------------------------------------------------------------------------
### Credits:
* the ideea: Hackaday.com - for the [article](https://hackaday.com/2020/12/28/teardown-creality-wifi-box) that set me on this journey
* the hard part: figgyc - for porting [OpenWrt](https://github.com/figgyc/openwrt/tree/wb01) to the Creality Wi-Fi Box
* the essentials: 
  - Kevin O'Connor - for [Klipper](https://github.com/KevinOConnor/klipper)
  - cadriel - for [fluidd](https://github.com/cadriel/fluidd)
  - Eric Callahan - for [Moonraker](https://github.com/Arksine/moonraker)
* the fine tuning: andryblack - for the OpenWrt Klipper [service](https://github.com/andryblack/openwrt-build/tree/master/packages/klipper/files)
* the encouragement: [Tom Hensel](https://github.com/gretel)- for supporting me into this

You can find me on:  
discord: jonah1024#4422  
email: hrapsaiona@gmail.com  
