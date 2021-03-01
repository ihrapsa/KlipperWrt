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
#### 1. Build OpenWrt image*
* only neccesary until the port gets merged and officially supported
#### 2. Install OpenWrt to the device
* I recommend following figgyc's [post](https://github.com/figgyc/figgyc.github.io/blob/source/posts.org#compiling-openwrt-for-the-creality-wb-01-tips-and-tricks). You'll find there his experience and a guide to compile OpenWrt. Here is his OpenWrt [branch](https://github.com/figgyc/openwrt/tree/wb01) with support for the Creality Wi-Fi Box 
#### 3. Setup Wi-FI
#### 4. Enable [extroot](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration) to expand storage on the TF card
- **4.1 Enable swap just in case** (though the existing 128mb RAM seemed more than enough)
<details>
  <summary>Click to expand!</summary>

`opkg update && opkg install swap-utils*`

`dd if=/dev/zero of=/overlay/swap.page bs=1M count=512`  
`mkswap /overlay/swap.page`  
`swapon /overlay/swap.page`  
`mount -o remount,size=200M /tmp`  
  
**put this inside /etc/rc.local above exit:**  

###activate the swap file on the SD card
`swapon /overlay/swap.page`  

###expand /tmp space
`mount -o remount,size=200M /tmp`  
</details>

#### 5. Install dependencies
* for Klipper and fluidd/mainsail
#### 6. Install Klipper
- **6.1 Use provided klipper service and place inside `/etc/init.d/`**
#### 7. Install fluidd/mainsail
- **7.1 Follow mainsail Manual Setup [Guide](https://docs.mainsail.xyz/setup/manual-setup)**
- **7.2 Use provided moonraker service and place inside `/etc/init.d/`**
- **7.3 Create and place all the nginx files inside `/etc/nginx/conf.d`***
* if you followed mainsail guide, `mainsail` should pe renamed to `mainsail.conf` and placed inside `/etc/nginx/conf.d/` alongside `common_vars.conf` and `upstreams.conf`
#### 7. Install mjpg-streamer
* use commands: `opkg update && opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www`
* connect a uvc webcam, configure /etc/config/mjpg-streamer to your likings and restart service `/etc/init.d/mjpg-streeamer restart`
* put the stream link inside the client(fluidd/mainsail) camera setting
#### 8. Enjoy 

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

You can find me on discord: jonah1024#4422
