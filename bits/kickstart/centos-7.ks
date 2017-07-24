################################# Install mode #################################

# Install Linux
install

################################# Network setup ################################

network --bootproto=dhcp --device=eth0 --onboot=on --nameserver=8.8.8.8,8.8.4.4,4.4.4.4 --noipv6

################################# Repositories #################################

# Centos 7 - Base
repo --name=CentOS7-Base      --baseurl=http://mirror.centos.org/centos/7.3.1611/os/x86_64/

# Centos 7 - Extras
repo --name=CentOS7-Extras    --baseurl=http://mirror.centos.org/centos/7.3.1611/extras/x86_64/

# Centos 7 - Updates
repo --name=CentOS7-Updates   --baseurl=http://mirror.centos.org/centos/7.3.1611/updates/x86_64/

# EPEL
repo --name=epel              --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64

# EL 7 - Base
repo --name=elrepo            --baseurl=http://elrepo.org/linux/elrepo/el7/x86_64/

# EL 7 - Kernel
repo --name=elrepo-kernel     --baseurl=http://elrepo.org/linux/kernel/el7/x86_64/

# EL 7 - Extras
repo --name=elrepo-extras     --baseurl=http://elrepo.org/linux/extras/el7/x86_64/

########################## System configuration ################################

# Accept Eula
eula --agreed

# Do not configure the X Window System
skipx

# Non-interactive command line mode
cmdline

# Use text install
text

# Set system language
lang en_US.UTF-8

# Keyboard
keyboard --vckeymap=us --xlayouts='us'

# Set time zone
timezone UTC --isUtc

# Do not run the Setup Agent on first boot
firstboot --disabled

# Firewall configuration
firewall --enable --ssh

# SELinux configuration
selinux --disabled

# Set the root password for now (it will be removed in %post)
rootpw --plaintext default

# Configure the logging level
logging --level=info

# System authorization information
authconfig --enableshadow --passalgo=sha512

# Enable necessary services.
services --disabled="firewalld,firstboot" --enabled="acpid,chronyd,cloud-init,iptables,network,rsyslog,sshd,tuned"

# Reboot after complete
reboot

############################# Disk partitioning ################################

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda --append="net.ifnames=0 biosdevname=0"

# Zero the MBR
zerombr

# Clear partition information
clearpart --all --initlabel

# Add a boot partition
part /boot --fstype xfs --size=200 --ondisk=sda

# Create a partition to hold the root LVM
part pv.2 --size=1 --grow --ondisk=sda

# Create the volume group on the partition
volgroup VolGroup00 pv.2

# Create the logical volumes for the group
logvol / --fstype xfs --name=lv_root --vgname=VolGroup00 --percent=100 --grow

############################### Packages #######################################

%packages --nobase --nocore --excludedocs

#
# Minimum packages
#

ca-certificates
chkconfig
chrony
cloud-init
cloud-utils                         # Needed to resize filesystem on boot
cloud-utils-growpart
coreutils
dkms
dhclient
elrepo-release
epel-release
iptables-services                   # Bring in good ole iptables
kernel-ml
kernel-ml-devel
kernel-ml-headers
kernel-ml-tools
kernel-ml-tools-libs
man
net-tools                            # Old habits die hard...
openssh-clients
openssh-server
parted
passwd
policycoreutils
rootfiles
sudo
xfsprogs
yum

#
# Extra packages to ease usability
#

curl
rsync
tar
vim
wget


#
# Remove unnecessary pacakges
#

-NetworkManager*
-aic94xx-firmware
-alsa-*
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-biosdevname
-btrfs-progs*
-centos-logos
-fprintd-pam
-intltool
-iprutils
-ipw*
-ivtv*
-iwl*firmware
-kernel
-kernel-devel
-kernel-headers
-kernel-tools
-kernel-tools-libs
-kexec-tools
-libertas*
-plymouth*
-postfix
-ql*-firmware
-rt*-firmware
-xorg-x11-drv-ati-firmware
-zd*-firmware

%end

######################### Pre-install script ##################################

%pre
%end

######################### Post-install script ##################################

%post --erroronfail --log=/root/ks-post.log

set -e   # exit immediately on error
set -x   # print commands and their arguments as they are executed
set -u   # error 1 if referencing a non-existing env var

# Create vagrant user# vagrant
groupadd vagrant -g 490
useradd vagrant -g vagrant -G wheel -u 490
echo "vagrant" | passwd --stdin vagrant

# Prevent yum from installing docs
sed -i '/distroverpkg=centos-release/a tsflags=nodocs' /etc/yum.conf

# The following packages are no longer needed after install so clean up
yum -y remove libX11 mesa-libgbm nvidia-* xorg-*

# Remove locale information
localedef --delete-from-archive $(localedef --list-archive | grep -v -i ^en | xargs )

# Prep the archive template
mv /usr/lib/locale/locale-archive  /usr/lib/locale/locale-archive.tmpl

# Rebuild archive
/usr/sbin/build-locale-archive

# Clear the template
:>/usr/lib/locale/locale-archive.

# Remove hostname
echo "Clearing out /etc/hostname"
cat /dev/null > /etc/hostname

echo "Cleaning /etc/sysconfig/network-scripts/ifcfg-*..."
for ifcfg in $(ls /etc/sysconfig/network-scripts/ifcfg-*)
do
  if [ "$(basename ${ifcfg})" != "ifcfg-lo" ]
  then
    # Remove old network configurations
    rm -rf $ifcfg
  fi
done

echo "Creating /etc/sysconfig/network-scripts/ifcfg-eth0..."
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
PERSISTENT_DHCLIENT="1"
EOF

# Remove interface persistence
echo "Removing persistent net rules..."
rm -f /etc/udev/rules.d/70-persistent-net.rules

# Disable crazy ethernet names
echo "Disabling Consistent Device Naming..."
sed -i '/^GRUB_CMDLINE_LINUX=.*/{s/"$/ net.ifnames=0"/}' /etc/sysconfig/grub
sed -i '/^GRUB_CMDLINE_LINUX=.*/{s/"$/ biosdevname=0"/}' /etc/sysconfig/grub
grubby --args="net.ifnames=0 biosdevname=0" --update-kernel=ALL

# Sanity check to make sure grub config is up to date
grub2-mkconfig -o /boot/grub2/grub.cfg

# Start dhclient on boot
cat <<EOF > /etc/init.d/net-autostart
#!/bin/bash
# Solution for "No Internet Connection from VMware"
#
### BEGIN INIT INFO
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
### END INIT INFO
dhclient -v
EOF
chmod 755 /etc/init.d/net-autostart
chkconfig --add net-autostart

# We cant remove firewalld in %packages -- as it causes an Xwindows prompt during the kickstart.
echo "Removing firewalld."
yum -C -y remove firewalld

# Configure cloud-init
cat <<EOF > /etc/cloud/cloud.cfg
bootcmd:
 - growpart /dev/sda 2
 - pvresize /dev/sda2
 - vgchange --sysinit -ay
 - lvextend -v -l +100%FREE /dev/VolGroup00/lv_root
 - xfs_growfs /dev/mapper/VolGroup00-lv_root

# The modules that run in the 'init' stage
cloud_init_modules:
 - migrator
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - users-groups
 - ssh

# The modules that run in the 'config' stage
cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - yum-add-repo
 - timezone
 - disable-ec2-metadata
 - runcmd

# The modules that run in the 'final' stage
cloud_final_modules:
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message

datasource_list:
  - None

# Enable the root account to allow for packer provisioning
disable_root: 0

growpart: 
  mode: auto 
  devices: ['/'] 
  ignore_growroot_disabled: false 

locale_configfile: /etc/sysconfig/i18n

mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']

resize_rootfs: True 
resize_rootfs_tmp: /dev

ssh_deletekeys:   0
ssh_genkeytypes:  ~

# Allow password auth for packer provisioning
ssh_pwauth: 1

syslog_fix_perms: ~

system_info:
  distro: rhel
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd

# vim:syntax=yaml
EOF

# General Cleanup
yum clean all
rm -f /root/anaconda-ks.cfg
rm -f /root/install.log
rm -f /root/install.log.syslog
find /var/log -type f -delete

%end
