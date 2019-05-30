#!/bin/bash

# Whiteout root partition
echo "==> Whiteout root partition..."
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`; 
let count--
dd if=/dev/zero of=/whitespace bs=1024 count=$count;
rm /whitespace;
 
# Whiteout /boot partition
echo "==> Whiteout boot partition..."
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;

# Whiteout swap partitions
echo "==> Whiteout swap partition(s)..."
swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
swapsize=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $3}')
if [ "$swappart" != "" ]; then
  swapoff $swappart;
  dd if=/dev/zero of=$swappart bs=1024 count=$swapsize;
  mkswap $swappart;
  swapon $swappart;
fi

sync
