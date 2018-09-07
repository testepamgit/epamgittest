#!/bin/bash
# Install jenkins and test whether it runs prints password on prompt or send via email
# if email variable is set Jenkins password will be set to your email of choice using mail command
# NOTE: bsd-mailx package should be installed in order for email sent to work and local machine should be running a properly configured
# relay SMTP
# Author: Georgi Georgiev 
# hipo@pc-freak.net
email='hipo@mail.com';

add_repos_install_jenkins () {
apt-get install --yes -qq apt-transport-https git curl

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

if [ "$(sed -n '/jenkins/p' /etc/apt/sources.list|wc -l)" -eq 0 ]; then
echo 'deb https://pkg.jenkins.io/debian binary/' >> /etc/apt/sources.list
fi

apt-get update -qq && apt-get install --yes -qq jenkins
}

check_j_install () {
if [[ "$(dpkg --get-selections | cut -f1|grep -i jenkins)" ]]; then echo 'succesfully installed'; 

else printf 'Problem in installing please check'; 
exit 1; 

fi

}

check_j_running_s_pass () {
if [[ $(ps -e -o command|grep -i jenkins) ]]; then 
echo 'Jenkins process working.'; 
echo ‘... do more here if necessery with some more commands’; 
else 
echo 'not working log to file' >> jenkins.log 
exit 1; 
fi

JENKINS_PASSWORD=`cat cat /var/lib/jenkins/secrets/initialAdminPassword`;
echo "Jenkins Admin password is $JENKINS_PASSWORD" | tee -a "jenkins_credentials.log";
if [ ! -z $email ]; then
echo $JENKINS_PASSWORD | mail -s "NEW Jenkins password" $email


fi

}

main () {
        add_repos_install_jenkins;
        check_j_install;
        check_j_running_s_pass;

}

main;
