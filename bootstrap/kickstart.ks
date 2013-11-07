install
cdrom
lang en_US.UTF-8
keyboard us
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw --plaintext password
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc America/Chicago
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"

clearpart --linux --drives=sda
volgroup VolGroup --pesize=4096 pv.008002
logvol / --fstype=ext4 --name=lv_root --vgname=VolGroup --grow --size=1024

part /boot --fstype=ext4 --size=500
part pv.008002 --grow --size=1

repo --name="CentOS"  --baseurl=cdrom:sr0 --cost=100
repo --name="PuppetLabs Products" --baseurl=http://yum.puppetlabs.com/el/6/products/x86_64 --cost=100
repo --name="PuppetLabs Deps" --baseurl=http://yum.puppetlabs.com/el/6/dependencies/x86_64 --cost=100

%packages --nobase
@core
puppet
git
%end

%post
chvt 3
echo "executing post install"
cat >/etc/sysconfig/puppet <<EOF
PUPPET_SERVER=puppet.localdomain
EOF
cat >/etc/hosts <<EOF
127.0.0.1 puppet.localdomain
EOF
chkconfig puppet on
chvt 1
