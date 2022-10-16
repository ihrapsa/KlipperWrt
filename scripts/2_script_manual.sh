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

echo "Installing klipper dependencies..."

opkg update && opkg install git-http unzip htop gcc patch;

opkg install python3 python3-pip python3-cffi python3-dev python3-greenlet python3-jinja2 python3-markupsafe;
pip install --upgrade pip;
pip install python-can configparser

echo "Cloning 250k baud pyserial"
git clone https://github.com/pyserial/pyserial /root/pyserial;
cd /root/pyserial
python /root/pyserial/setup.py install;
cd /root/
rm -rf /root/pyserial;


echo " "
echo "##############################"
echo "### Moonraker dependencies ###"
echo "##############################"
echo " "


echo "Installing moonraker python3 packages..."
opkg install python3-tornado python3-pillow python3-distro python3-curl python3-zeroconf python3-paho-mqtt python3-yaml python3-requests ip-full libsodium --force-overwrite;

echo "Upgrading setuptools..."
pip install --upgrade setuptools;

echo "Installing pip3 packages..."
pip install pyserial-asyncio lmdb streaming-form-data inotify-simple libnacl preprocess-cancellation apprise ldap3 dbus-next;

#--use-pep517

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

mkdir -p /root/printer_data/config;


echo " "
echo "#################"
echo "### Moonraker ###"
echo "#################"
echo " "

git clone https://github.com/Arksine/moonraker.git /root/moonraker;
git -C /root/moonraker checkout 06279d0e10ae4e0349f7b415756821d7ca38774b
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
	   wget -q -O /root/printer_data/config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/fluidd_moonraker.conf;
	   wget -q -O /etc/nginx/conf.d/fluidd.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/fluidd.conf;
     wget https://github.com/ihrapsa/KlipperWrt/raw/main/klipper_config/fluidd.cfg -P /root/printer_data/config/
     
	   
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
	   wget -q -O /root/printer_data/config/moonraker.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/moonraker/mainsail_moonraker.conf;
	   wget -q -O /etc/nginx/conf.d/mainsail.conf https://raw.githubusercontent.com/ihrapsa/KlipperWrt/main/nginx/mainsail.conf;
     wget https://github.com/ihrapsa/KlipperWrt/raw/main/klipper_config/mainsail.cfg -P /root/printer_data/config/
	   
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



opkg install wget-ssl;

rm -rf /tmp/opkg-lists 

echo "Installing ffmpeg offline pacakges..."
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


echo "Installing Timelapse packages..."
git clone https://github.com/ihrapsa/moonraker-timelapse.git /root/moonraker-timelapse;
/root/moonraker-timelapse/install.sh;

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
