Please create project on GitHub with the script (BASH, Ansible, Python, etc.) All tasks need be executed on the VM:

Example GITHUB account created for the purpose is: https://github.com/testepamgit/
user: testepamgit
p: TestqWerty43#

To use GITHub without authenticatoin ssh id_rsa key is used

(Here inside web browser added key to GITHub page to be able to authenticate passwordless), commands used to generate the key are below:
====================================================
ssh-keygen -t rsa -b 4096 -C "hipodilski@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa
To add a new pository (epamgittest) and push commited files from local .git repo from the VM to remote git repo:
========================================================================================

sh git_create.sh epamgittest
It receives one argument which is the repository name to be created.

(Script is a little buggy but it basicly does what it is supposed to could be improved)


    1. Add user (Login: devops, pass: testpass) to the system
#!/bin/bash
# apt-get install –yes sudo
# useradd devops --home /home/devops
# mkdir /home/devops
       # chown -R devops:devops /home/devops
# echo 'devops:testpass' | chpasswd


    2. Grant admin privileges for user from point 1 and allow him to use “sudo” without entering password

#!/bin/bash
echo 'devops ALL=(ALL) NOPASSWD: ALL
       ' >> /etc/sudoers
       

Note: Task 1 & 1 are done via a script create_user.sh in repository

    3. Install Jenkins (any way, Docker, .deb, .rpm)

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
echo ‘

if [ "$(sed -n '/jenkins/p' /etc/apt/sources.list|wc -l)" -eq 0 ]; then
echo 'deb https://pkg.jenkins.io/debian binary/' >> /etc/apt/sources.list
fi

apt-get update -qq && apt-get -qq install --yes jenkins
}

check_j_install () {
if [[ $(dpkg --get-selections | cut -f1|grep -i jenkins) ]]; then echo 'succesfully installed'; 

else printf 'Problem in installing please check'; exit 1; 
fi

}

check_j_running_s_pass () {
if [[ $(ps -e -o command|grep -i jenkins) ]]; then echo 'working' echo ‘do more here if necessery with some more commands’; else echo 'not working log to file' >> jenkins.log exit 1; fi

JENKINS_PASSWORD=`cat cat /var/lib/jenkins/secrets/initialAdminPassword`;
echo "Jenkins Admin password is $JENKINS_PASSWORD";
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


Deployed current VM Jenkins credentials are:
========================
http://localhost:8080/
Jenkins user: 
admin 
pass:testpass

    4. Create a freestyle Job in Jenkins that will show environment variables.
I assume here the freestyle job has to be created manually, job is created and made to simply execute the shell command env  and it executes fine was that the task ?



The freestyle job is inside the jenkins and called 


** - Additional
    5. ** Deploy job to the same project on GitHub and allow Jenkins to grub it, and run after point 4 automatically 
I have added a new Token via https://github.com/settings/tokens to connect Jenkins to github

Token is: 8481f440fd8fe762fadb84d290b455a990350dd5

For task 5 actually it is necessery to configure GITSCM Polling (in Jenkins Build Triggers section) and then use Webhook on github website but for that you need to have a public IP (setting up DynDNS and a like is an option but I don’t have the time to do it at the moment …).
Just for the sake of showing up it can be done I’ve Enabled Web Hook pointing to the repository testepamgit (with test URL http://ci.jenkins-ci.org/github-webhook/).

Web Hooks are enabled from Repository → Settings → Integration and Services

Conclusion and notes

There are many other ways to the tasks. From the assignment given it was not crear to me, do you want me to create the free style job inside a Jenkins Web interface or you want me to do it via a script, so I made it from the tool itself, I assume there is also an API which can be used to automate the task but I didn’t have the time to research it further, however as I said in the interview my experience with Jenkins so far is basic though if necessery it can be further learned and done.


P.S. You can use any modern Linux distro, like Debian, Ubuntu, Centos.

Results:
    • URL on git repo
    • VM image
If additional task is done, Just an URL on Repo is possible
