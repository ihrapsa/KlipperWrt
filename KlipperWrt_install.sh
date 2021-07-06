#!/bin/sh

echo " "
echo "This script will attempt to install either fluidd or Mainsail at your choice"
echo " "
echo "   ###################################################"
echo "   ## Make sure you've got a microSD card plugged!  ##"
echo "   ###################################################"
echo " "
read -p "Press [ENTER] to continue...or [ctrl+c] to exit"



format(){
	while true; do
	    read -p "This script will format your sdcard. Are you sure about this? [y/n]: " yn
	    case $yn in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	    esac
	done
	
	umount /dev/mmcblk0p1;

	yes | mkfs.ext4 /dev/mmcblk0p1;

	mount /dev/mmcblk0p1 /mnt;
}


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
	   wget -O /mnt/fluiddWrt.tar.gz https://github.com/ihrapsa/KlipperWrt/releases/latest/download/fluiddWrt.tar.gz;
	   
	   
	   echo "***************************"
	   echo "** Finished downloading! **"
	   echo "***************************"
	   sleep 1
	   
	   echo "***************************"
	   echo "**      Untarring...     **"
	   echo "***************************"
	   
	   tar -xzvf /mnt/fluiddWrt.tar.gz -C /mnt;
	   
	   echo "***************************"
	   echo "**  Finished untarring!  **"
	   echo "***************************"

	   sleep 1
	   
	   echo "***************************"
	   echo "**       Cleaning...     **"
	   echo "***************************"
	   rm /mnt/fluiddWrt.tar.gz;
	   umount /dev/mmcblk0p1;
	   echo "***************************"
	   echo "**         Done!         **"
	   echo "***************************"
	   echo -ne '\n'
	   extroot
	   ;;
	  2) 
	   echo "You chose Mainsail"
	   echo "Installing Mainsail..."
	   echo " "
	   echo "***************************"
	   echo "**     Downloading...    **"
	   echo "***************************"
	   echo " "
	   wget -O /mnt/MainsailWrt.tar.gz https://github.com/ihrapsa/KlipperWrt/releases/latest/download/MainsailWrt.tar.gz;
	  	   
	   
	   echo "***************************"
	   echo "** Finished downloading! **"
	   echo "***************************"
	   sleep 1
	   
	   echo "***************************"
	   echo "**      Untarring...     **"
	   echo "***************************"
	   
	   tar -xzvf /mnt/MainsailWrt.tar.gz -C /mnt;
	   
	   echo "***************************"
	   echo "**  Finished untarring!  **"
	   echo "***************************"

	   sleep 1
	   
	   echo "***************************"
	   echo "**       Cleaning...     **"
	   echo "***************************"
	   rm /mnt/MainsailWrt.tar.gz;
	   umount /dev/mmcblk0p1;
	   echo "***************************"
	   echo "**         Done!         **"
	   echo "***************************"
	   echo -ne '\n'
	   extroot
	   ;;
	  3) 
	   echo "Quitting...";;
	  *) 
	   echo "invalid option";;
	esac
}

extroot(){
	echo " "
	sleep 1
	echo -ne 'Making extroot...     [=>                                ](6%)\r'
	DEVICE="$(sed -n -e "/\s\/overlay\s.*$/s///p" /etc/mtab)";
	echo -ne 'Making extroot...     [===>                              ](12%)\r'
	uci -q delete fstab.rwm;
	echo -ne 'Making extroot...     [=====>                            ](18%)\r'
	uci set fstab.rwm="mount";
	echo -ne 'Making extroot...     [=======>                          ](25%)\r'
	uci set fstab.rwm.device="${DEVICE}";
	echo -ne 'Making extroot...     [=========>                        ](31%)\r'
	uci set fstab.rwm.target="/rwm";
	echo -ne 'Making extroot...     [===========>                      ](37%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [=============>                    ](43%)\r'
	DEVICE="/dev/mmcblk0p1";
	echo -ne 'Making extroot...     [===============>                  ](50%)\r'
	eval $(block info "${DEVICE}" | grep -o -e "UUID=\S*");
	echo -ne 'Making extroot...     [=================>                ](56%)\r'
	uci -q delete fstab.overlay;
	echo -ne 'Making extroot...     [===================>              ](62%)\r'
	uci set fstab.overlay="mount";
	echo -ne 'Making extroot...     [=====================>            ](68%)\r'
	uci set fstab.overlay.uuid="${UUID}";
	echo -ne 'Making extroot...     [=======================>          ](75%)\r'
	uci set fstab.overlay.target="/overlay";
	echo -ne 'Making extroot...     [=========================>        ](81%)\r'
	uci commit fstab;
	echo -ne 'Making extroot...     [===========================>      ](87%)\r'
	mount /dev/mmcblk0p1 /mnt;
	echo -ne 'Making extroot...     [=============================>    ](93%)\r'
	cp -f -a /overlay/. /mnt;
	echo -ne 'Making extroot...     [===============================>  ](98%)\r'
	umount /mnt;
	echo -ne 'Making extroot...     [=================================>](100%)\r'
	echo -ne '\n'

	echo "Please reboot for changes to take effect!";
}

format
choose
