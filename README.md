# KlipperWrt
 Klipper and fluidd/mainsail config files for OpenWrt embeded devices like the Creality Wi-Fi Box.

## What is the Creality [Wi-Fi Box](https://www.creality.com/goods-detail/creality-box-3d-printer)?
    - A router box device released by Creality meant to add network control to your printer.  Big claims, lots of problems and frustrations. No desktop control, only mobile. No custom slicing only cloud based. No camera support, only claims.

## What is [OpenWrt](https://github.com/openwrt/openwrt)?
    - A Linux OS built for embeded devices, routers especially. Light, Open Source with a great community and packages that gives your device the freedom it deserves. 
    
## What is [Klipper](https://github.com/KevinOConnor/klipper)?
    - A 3d-printer firmware. It runs on any kind of computer taking advantage of the host cpu. Extremely light on cpu, lots of feautres

## What is [fluidd](https://github.com/cadriel/fluidd) / [mainsail](https://github.com/meteyou/mainsail)?
    - These are free and open-source Klipper web interface clients for managing your 3d printer.
    
## What is Moonraker?
    - A Python 3 based web server that exposes APIs with which client applications (fluidd or mainsail) may use to interact with Klipper

--------------------------------------------------------------------------

# Steps:
## 1. Build OpenWrt image*
        - *only neccesary until the port gets merged and officially supported
## 2. Install OpenWrt to the device
## 3. Setup Wi-FI
## 2. Enable extroot to expand storage on the TF card
###     2.1 Enable swap just in case (though 128mb seemed more than enough)
## 3. Install dependencies
        - for Klipper, fluidd/mainsail
## 4. Install Klipper
###     4.1 Use provided klipper service
## 5. Install fluidd/mainsail
###     5.1 Follow mainsail Manual Setup [Guide](https://docs.mainsail.xyz/setup/manual-setup)
###     5.2 Use provided moonraker service
###     5.3 Create and place all the nginx files inside conf.d*
        - *if you followed mainsail guide, "mainsail" should pe renamed to "mainsail.conf" and placed inside /etc/nginx/conf.d/ alongside "common_vars.conf" and "upstreams.conf"
## 6. Install mjpg-streamer
        - connect a uvc webcam, configure /etc/config/mjpg-streamer to your likings and restart service "/etc/init.d/mjpg-streeamer restart"
        - put the stream link inside the client(fluidd/mainsail) camera setting
## 7. Enjoy 

--------------------------------------------------------------------------

### Credits:
> the ideea: Hackaday.com - for the [article](https://hackaday.com/2020/12/28/teardown-creality-wifi-box) that set me on this journey
> the hard part: figgyc - for porting [OpenWrt](https://github.com/figgyc/openwrt/tree/wb01) to the Creality Wi-Fi Box
> the essentials: Kevin O'Connor - for [Klipper](https://github.com/KevinOConnor/klipper)
                           cadriel - for [fluidd](https://github.com/cadriel/fluidd)
                           Eric Callahan - for [Moonraker](https://github.com/Arksine/moonraker)
> the fine tuning: andryblack - for the OpenWrt Klipper [service](https://github.com/andryblack/openwrt-build/tree/master/packages/klipper/files)
> the encouragement: Tom Hensel - for supporting me into this

You can find me on discord: jonah1024#4422
