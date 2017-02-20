1. Burn standard Raspian image
2. Boot Pi from card and run the edu-image.sh script on the Pi
3. Remove the card and place in laptop, mount both boot and main partitions
4. Copy cmdline.txt to the boot partition
5. Copy resize2fs_once to /etc/init.d/
6. Create symlink - `sudo ln -s /media/SD/etc/init.d/resize2fs_once /media/SD/etc/rc3.d/S01resize2fs_once` for instance.
7. Unmount both partitions and run resize.sh to reduce partition size.
8. A backup of the image will be created in ~/backups that can be used to create new cards if needed.
