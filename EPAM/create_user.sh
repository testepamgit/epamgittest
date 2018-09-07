#!/bin/bash
# Create new user/group and add nopasswd login to sudoers
# Author: Georgi Georgiev 
# has to be run sa root - sudo devops
# hipo@pc-freak.net

u_id='devops';
g_id='devops';
pass='testpass';
sudoers_f='/etc/sudoers';

check_install_sudo ()  {
if [ $(dpkg --get-selections | cut -f1|grep -E '^sudo') ]; then
apt-get install --yes sudo
else
	printf "Nothing to do sudo installed";
fi
}

check_install_user () {

if [ "$(sed -n "/$u_id/p" /etc/passwd|wc -l)" -eq 0 ]; then 
apt-get install --yes sudo
useradd $u_id --home /home/$u_id
mkdir /home/$u_id
chown -R $u_id:$g_id /home/$u_id
echo "$u_id:$pass" | chpasswd
cp -rpf /etc/bash.bashrc /home/$u_id
if [ "$(sed -n "/$u_id/p" $sudoers_f|wc -l)" -eq "0" ]; then
echo "$u_id ALL=(ALL) NOPASSWD: ALL" >> $sudoers_f
else
	echo "$u_id existing. Exiting ..";
	exit 1;
fi

else
	echo "Will do nothing because $u_id exists";
fi

}

check_install_sudo;
check_install_user;

