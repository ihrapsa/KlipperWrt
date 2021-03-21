**Flashing:**  
  
1. Rename `*factory.bin` to `cxsw_update.tar.bz2`  
2. Copy it to the root of a FAT32 formatted microSD card.  
3. Turn on the device, wait for it to start, then insert the card. The stock firmware reads the `install.sh` script from this archive and flashes the new OpenWrt image.  
4. `ssh` into it with ethernet `ssh root@192.168.1.1` or get into serial baud: `57600`, enable radio in `/etc/config/wireless`, reboot, the box will create an AP `OpenWrt`- connect to it -> `ssh` and continue Wi-fi internet setup.
