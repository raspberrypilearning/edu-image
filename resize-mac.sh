#!/bin/bash -ex # The x is to be used for debugging.

#------------------------------------------------------------------------------
#
#  9 may 2016, backuPi.sh 
# 
#
#  Calculates the minimum size of the sd card, and then resizes filesystem
#  and partition.
#  Subsequently creates an image of the relevant partitions space.
#
#
#
#------------------------------------------------------------------------------

function calcMiB()
{
   # Calculate size in MiB, for easier reading.
   local partsizeblocks=$1
   local KBperblock=$2
   local partsizeKiB=$(( ${partsizeblocks} * ${KBperblock} ))
   local quotientMiB="$(( (${partsizeblocks} * ${KBperblock}) / 1024 ))"
   local modulusMiB=$(( ($partsizeKiB - ($quotientMiB * 1024))*1000/1024))
   local modulusMiB2="$(( (${partsizeblocks} % ${KBperblock}) / 1024))"
   echo "${quotientMiB},${modulusMiB} MiB."
}

# check which drive is the sd card:
echo "Please select the drive you want to format and write an image to."
echo "The following filesystems have been found:"
diskutil list
read -e -p "Which blockdevice: " myblkdev
read -e -p "Which partition do you want to shrink: " -i "2" targetpartnr
targetpart="${myblkdev}p${targetpartnr}"
echo ${myblkdev}
echo ${targetpartnr}
echo ${targetpart}

# Unmount directories, otherwise online shrinking from resize2fs would be
# required but this throws an error.
if grep -s "${myblkdev}" /proc/mounts
then
   echo "Start unmounting partitions"
   sudo umount -v "/dev/${myblkdev}"* # Questionmark is wildcard.
fi

# Check the filesystem/partition.
sudo e2fsck -fy "/dev/${targetpart}"

myblockcount=$(sudo tune2fs -l "/dev/${targetpart}" | grep 'Block count' | awk '{print $3}')
myfreeblocks=$(sudo tune2fs -l "/dev/${targetpart}" | grep 'Free blocks' | awk '{print $3}')
myblocksize=$(sudo tune2fs -l "/dev/${targetpart}" | grep 'Block size' | awk '{print $3}')
mysectorsize=$(sudo sfdisk -l "/dev/${myblkdev}" | grep Units | awk '{print $8}')
mystartsector=$(sudo fdisk -l "/dev/${myblkdev}" | grep "${targetpart}" | awk '{print $2}')

# Calculate the smallest partition size, in blocks.
myusedblocks=$(( $myblockcount - $myfreeblocks ))
# Calculate target partion size, adding a bit of margin, about 8%.
mytargetblocks=$(( $myusedblocks + ($myusedblocks * 2 / 25) ))

# Calculate KiB per block to aid further calculation in KiB's:
if (( "${myblocksize}" >= "1024" ))
then
   KBperblock=$(( $myblocksize/1024 ))
else
   echo "Blocksize is awkward: ${myblocksize}. Not sure what to do, stopping."
   exit
fi

# Round up new part size to multiple of blocksize to facilitate creation.
mynewpartsize=$(( (($mytargetblocks + $KBperblock-1) / $KBperblock) * $KBperblock ))

# Calculate and print the existing data and target partition size.
echo ""
echo "The size of the data on partion /dev/${targetpart} is \
$( calcMiB ${myusedblocks} ${KBperblock} )"
echo ""
echo "The new size of the data on partion /dev/${targetpart} will be \
$( calcMiB ${mytargetblocks} ${KBperblock} )"
echo ""

# Calculate multiplier from sector size to block size
sectorsperblock=$(( $myblocksize/$mysectorsize  ))
# Calculate end point in sectors, that is what fdisk requires.
mynewendpoint=$(( $mystartsector + ($mynewpartsize * $sectorsperblock) ))

# Start execution:
# Resize the filesystem, values in 1024 bytes, see the "K" at the end.
# Example, if blocksize was 4096, nr of blocks x 4 is the resize value.
sudo resize2fs -fp "/dev/${targetpart}" $(( $mynewpartsize * $KBperblock ))K
# Resize partion, to make matters complicated values are in sector sizes.
# NB, the -s switch does not work, putting Yes after the command is the work around.
sudo parted "/dev/${myblkdev}" unit s resizepart "${targetpartnr}" "${mynewendpoint}" yes
sync

# Mounting the drives does not work: error looking up object with path ....
#udisksctl mount -p block_devices/sdc1
#udisksctl mount -p block_devices/sdc2
#udisksctl mount -b /dev/sdc1
#udisksctl mount -b /dev/sdc2

# Backup resized image
read -e -p "Backup the resized image? [Y/N] " -i "Y" backupchoice

if [[ "${backupchoice}" =~ ^([yY][eE][sS]|[yY])$ ]]
then
   mkdir -p ~/backups
   read -e -p "Filename :" -i "$(date +%g%m%d)-raspbianbackup.img" Pibackupname
   sudo dd if="/dev/${myblkdev}" | pv | sudo dd of=~/backups/"${Pibackupname}" bs=512 count="${mynewendpoint}"
   echo "Backup successful."
fi
exit
