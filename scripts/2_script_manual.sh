#!/bin/sh

echo " "
echo "   ################################################"
echo "   ## Did you execute 1_format_extroot.sh first? ##"
echo "   ################################################"
echo " "
read -p "Press [ENTER] if YES ...or [ctrl+c] to exit"


echo " "
echo "This script will download and install all packages form the internet"
echo " "
echo "   #####################################"
echo "   ## Make sure extroot is enabled... ##"
echo "   #####################################"
echo " "
read -p "Press [ENTER] to check if extroot is enabled ...or [ctrl+c] to exit"

df -h;



echo " "
echo "   ############################################"
echo "   ## Is /dev/mmcblk0p1 mounted on /overlay? ##"
echo "   ############################################"
echo " "
read -p "Press [ENTER] if YES... or [ctrl+c] to exit"

echo " "
echo "   ########################################################"
echo "   ## Make sure you've got a stable Internet connection! ##"
echo "   ########################################################"
echo " "
read -p "Press [ENTER] to Continue ...or [ctrl+c] to exit"

echo " "
echo "#################"
echo "###   SWAP    ###"
echo "#################"
echo " "

echo "Creating swap file"
dd if=/dev/zero of=/overlay/swap.page bs=1M count=512;
echo "Enabling swap file"
mkswap /overlay/swap.page;
swapon /overlay/swap.page;
mount -o remount,size=256M /tmp;

echo "Updating rc.local for swap"
rm /etc/rc.local;
cat << "EOF" > /etc/rc.local
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

###activate the swap file on the SD card  
swapon /overlay/swap.page  

###expand /tmp space  
mount -o remount,size=256M /tmp

exit 0
EOF

echo " "
echo "############################"
echo "### Klipper dependencies ###"
echo "############################"
echo " "

echo "Installing dependencies..."
### Backup no working distfeed.conf and opkg.conf for future use
mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf_orig_old;
mv /etc/opkg.conf /etc/opkg.conf_orig;

## create new distfeeds.conf using 21.02.1 releases 
cat << "EOF" > /etc/opkg/distfeeds.conf
src/gz openwrt_core https://downloads.openwrt.org/releases/21.02.1/targets/ramips/mt76x8/packages
src/gz openwrt_base https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/base
src/gz openwrt_luci https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/luci
src/gz openwrt_packages https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/packages
src/gz openwrt_routing https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/routing
src/gz openwrt_telephony https://downloads.openwrt.org/releases/21.02.1/packages/mipsel_24kc/telephony
EOF

## create new opkg.conf with check_signature disable
cat << "EOF" > /etc/opkg.conf
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay
#option check_signature
EOF

opkg update && opkg install git-http unzip htop zram-swap gcc;

echo "Changing distfeeds for python2..."
mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf_orig;
cat << "EOF" > /etc/opkg/distfeeds.conf
src/gz openwrt_core https://downloads.openwrt.org/releases/19.07.7/targets/ramips/mt76x8/packages
src/gz openwrt_base https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/base
src/gz openwrt_luci https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/luci
src/gz openwrt_packages https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/packages
src/gz openwrt_routing https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/routing
src/gz openwrt_telephony https://downloads.openwrt.org/releases/19.07.7/packages/mipsel_24kc/telephony
EOF

opkg update;
opkg install python python-pip python-cffi python-dev gcc;

echo "Cloning 250k baud pyserial"
git clone https://github.com/ihrapsa/pyserial /root/pyserial;
cd /root/pyserial
python /root/pyserial/setup.py install;
cd /root/
rm -rf /root/pyserial;

echo "Installing pip2 packages..."
pip install greenlet==0.4.15 jinja2 python-can==3.3.4 configparser==4.0.2;


echo " "
echo "##############################"
echo "### Moonraker dependencies ###"
echo "##############################"
echo " "

echo "Switching to original distfeeds..."
mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf_v19;
mv /etc/opkg/distfeeds.conf_orig /etc/opkg/distfeeds.conf;

### disable opkg.conf restore as we are using release distfeeds
### rm /etc/opkg.conf;
### mv /etc/opkg.conf_orig /etc/opkg.conf;

echo "Updating original distfeeds..."
opkg update;
echo "Installing python3 packages..."
opkg install python3 python3-pip python3-pyserial python3-pillow python3-tornado python3-distro python3-curl libcurl4 libsodium libffi ip-full dbus --force-overwrite;

echo "Fixing libffi symlinks..."
ln -s /usr/lib/libffi.so.8 /usr/lib/libffi.so.7;
ln -s /usr/lib/libffi.so.8 /usr/lib/libffi.so.7.1.0;

echo "Upgrading setuptools..."
pip3 install --upgrade setuptools;

echo "Installing pip3 packages..."
pip3 install inotify-simple python-jose libnacl paho-mqtt==1.5.1 dbus-next zeroconf preprocess-cancellation jinja2;


echo "Downloading lmdb and streaming-form-data package..."

wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/python3-lmdb%2Bstreaming-form-data_packages_1.0-1_mipsel_24kc.ipk -P /root/;

echo "Installing lmdb and streaming-form-data package..."
opkg install /root/*ipk;
rm -rf *ipk;

echo " "
echo "###############"
echo "###  Nginx  ###"
echo "###############"
echo " "

echo "Installing nginx..."
opkg install nginx-ssl;

echo " "
echo "###############"
echo "### Klipper ###"
echo "###############"
echo " "

echo "Cloning Klipper..."
git clone https://github.com/KevinOConnor/klipper.git /root/klipper;

echo "Creating klipper service..."
wget https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/Services/klipper -P /etc/init.d/;
chmod 755 /etc/init.d/klipper;
/etc/init.d/klipper enable;

mkdir /root/klipper_config /root/klipper_logs /root/gcode_files;


echo " "
echo "#################"
echo "### Moonraker ###"
echo "#################"
echo " "

git clone https://github.com/ihrapsa/moonraker.git /root/moonraker;
wget https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/Services/moonraker -P /etc/init.d/
chmod 755 /etc/init.d/moonraker
/etc/init.d/moonraker enable
wget https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/upstreams.conf -P /etc/nginx/conf.d/
wget https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/common_vars.conf -P /etc/nginx/conf.d/
/etc/init.d/nginx enable


echo " "
echo "#################"
echo "###  Client   ###"
echo "#################"
echo " "

choose(){
	echo " "
	echo "Choose prefered Klipper client:"
	echo "  1) fluidd"
	echo "  2) Mainsail"
	echo "  3) Quit"
	echo " "
	read n
	case $n in
	  1) 
	   echo "You chose fluidd"
	   sleep 1
	   echo "Installing fluidd..."
	   sleep 1
	   echo " "
	   echo "***************************"
	   echo "**     Downloading...    **"
	   echo "***************************"
	   echo " "
	   mkdir /root/fluidd;
	   wget -q -O /root/fluidd/fluidd.zip https://github.com/cadriel/fluidd/releases/latest/download/fluidd.zip && unzip /root/fluidd/fluidd.zip -d /root/fluidd/ && rm /root/fluidd/fluidd.zip;
	   wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/fluidd_moonraker.conf;
	   wget -q -O /etc/nginx/conf.d/fluidd.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/fluidd.conf;
     wget https://github.com/ihrapsa/KlipperWrt/raw/main/klipper_config/fluidd.cfg -P /root/klipper_config/
     wget https://github.com/ihrapsa/KlipperWrt/raw/main/klipper_config/fluidd_macros.cfg -P /root/klipper_config/
	   
	   echo "***************************"
	   echo "**         Done!         **"
	   echo "***************************"
	   echo -ne '\n'
	   ;;
	  2) 
	   echo "You chose Mainsail"
	   echo "Installing Mainsail..."
	   echo " "
	   echo "***************************"
	   echo "**     Downloading...    **"
	   echo "***************************"
	   echo " "
	   mkdir /root/mainsail;
	   wget -q -O /root/mainsail/mainsail.zip https://github.com/mainsail-crew/mainsail/releases/latest/download/mainsail.zip && unzip /root/mainsail/mainsail.zip -d /root/mainsail/ && rm /root/mainsail/mainsail.zip;
	   wget -q -O /root/klipper_config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/mainsail_moonraker.conf;
	   wget -q -O /etc/nginx/conf.d/mainsail.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/mainsail.conf;
     wget https://github.com/ihrapsa/KlipperWrt/raw/main/klipper_config/mainsail.cfg -P /root/klipper_config/
	   
	   echo "***************************"
	   echo "**         Done          **"
	   echo "***************************"
	   echo " "
	   ;;
	  3) 
	   echo "Quitting...";;
	  *) 
	   echo "invalid option";;
	esac
}

choose;


echo " "
echo "#################"
echo "###  Webcam   ###"
echo "#################"
echo " "

echo "Installing mjpg-streamer..."
opkg install v4l-utils;
opkg install mjpg-streamer-input-uvc mjpg-streamer-output-http mjpg-streamer-www;

rm /etc/config/mjpg-streamer;
cat << "EOF" > /etc/config/mjpg-streamer
config mjpg-streamer 'core'
        option enabled '0'
        option input 'uvc'
        option output 'http'
        option device '/dev/video0'
        option resolution '640x480'
        option yuv '0'
        option quality '80'
        option fps '5'
        option led 'auto'
        option www '/www/webcam'
        option port '8080'
        #option listen_ip '192.168.1.1'
        #option username 'openwrt'
        #option password 'openwrt'
EOF

/etc/init.d/mjpg-streamer enable;
ln -s /etc/init.d/mjpg-streamer /etc/init.d/webcamd;

echo " "
echo "###################"
echo "### Hostname/ip ###"
echo "###################"
echo " "

echo "Using hostname instead of ip..."
opkg install avahi-daemon-service-ssh avahi-daemon-service-http;

echo " "
echo "#################"
echo "### Timelapse ###"
echo "#################"
echo " "

echo "Installing Tiemlapse packages..."
#wget https://raw.githubusercontent.com/FrYakaTKoP/moonraker/c9ec89ca8a633501b200bce8748538b77b085a57/moonraker/components/timelapse.py -P /root/moonraker/moonraker/components;
git clone https://github.com/mainsail-crew/moonraker-timelapse.git /root/moonraker-timelapse;
/root/moonraker-timelapse/install.sh;

opkg install wget-ssl;

rm -rf /tmp/opkg-lists 

echo "Installing Timelapse offline pacakges..."
mkdir /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/Packages -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/Packages.gz -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/Packages.manifest -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/Packages.sig -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/alsa-lib_1.2.4-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/fdk-aac_2.0.1-4_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/ffmpeg_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/ffprobe_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libatomic1_8.4.0-3_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libbz21.0_1.0.8-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libffmpeg-full_4.3.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libgmp10_6.2.1-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libgnutls_3.7.2-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libnettle8_3.6-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/libx264_2020-10-26-1_mipsel_24kc.ipk -P /root/ffmpeg;
wget https://github.com/ihrapsa/KlipperWrt/raw/main/packages/ffmpeg/shine_3.1.1-1_mipsel_24kc.ipk -P /root/ffmpeg;


opkg install /root/ffmpeg/*ipk --force-overwrite;
rm -rf /root/ffmpeg;



echo " "
echo "########################"
echo "### tty hotplug rule ###"
echo "########################"
echo " "

echo "Install tty hotplug rule..."
opkg update && opkg install usbutils;
cat << "EOF" > /etc/hotplug.d/usb/22-tty-symlink
# Description: Action executed on boot (bind) and with the system on the fly
PRODID="1a86/7523/264" #change here according to "PRODUCT=" from grep command 
SYMLINK="ttyPrinter" #you can change this to whatever you want just don't use spaces. Use this inside printer.cfg as serial port path
if [ "${ACTION}" = "bind" ] ; then
  case "${PRODUCT}" in
    ${PRODID}) # mainboard product id prefix
      DEVICE_TTY="$(ls /sys/${DEVPATH}/tty*/tty/)"
      # Mainboard connected to USB1 slot
      if [ "${DEVICENAME}" = "1-1.4:1.0" ] ; then
        ln -s /dev/${DEVICE_TTY} /dev/${SYMLINK}
        logger -t hotplug "Symlink from /dev/${DEVICE_TTY} to /dev/${SYMLINK} created"

      # Mainboard connected to USB2 slot
      elif [ "${DEVICENAME}" = "1-1.2:1.0" ] ; then
        ln -s /dev/${DEVICE_TTY} /dev/${SYMLINK}
        logger -t hotplug "Symlink from /dev/${DEVICE_TTY} to /dev/${SYMLINK} created"
      fi
    ;;
  esac
fi
# Action to remove the symlinks
if [ "${ACTION}" = "remove" ]  ; then
  case "${PRODUCT}" in
    ${PRODID})  #mainboard product id prefix
     # Mainboard connected to USB1 slot
      if [ "${DEVICENAME}" = "1-1.4:1.0" ] ; then
        rm /dev/${SYMLINK}
        logger -t hotplug "Symlink /dev/${SYMLINK} removed"

      # Mainboard connected to USB2 slot
      elif [ "${DEVICENAME}" = "1-1.2:1.0" ] ; then
        rm /dev/${SYMLINK}
        logger -t hotplug "Symlink /dev/${SYMLINK} removed"
      fi
    ;;
  esac
fi
EOF

echo " "
echo "########################"
echo "###  Fixing logs...  ###"
echo "########################"
echo " "
echo "Creating system.log..."

uci set system.@system[0].log_file='/root/klipper_logs/system.log';
uci set system.@system[0].log_size='51200';
uci set system.@system[0].log_remote='0';
uci commit;

echo " "
echo "Installing logrotate..."
echo " "
opkg install logrotate;

echo " "
echo "Creating cron job..."
echo " "
echo "0 8 * * * *     /usr/sbin/logrotate /etc/logrotate.conf" >> /etc/crontabs/root


echo " "
echo "Creating logrotate configuration files..."
echo " "

cat << "EOF" > /etc/logrotate.d/klipper
/root/klipper_logs/klippy.log
{
    rotate 7
    daily
    maxsize 64M
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
}
EOF

cat << "EOF" > /etc/logrotate.d/moonraker
/root/klipper_logs/moonraker.log
{
    rotate 7
    daily
    maxsize 64M
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
}
EOF

echo " "
echo "#################"
echo "###   Done!   ###"
echo "#################"
echo " "

echo "Please reboot for changes to take effect...";
echo "...then proceed configuring your printer.cfg!";
