#!/bin/sh
echo "Control Node Preparation ..."
yum install -y epel-release
yum install -y git vim byobu python3-pip sshpass gpm
systemctl --now enable gpm

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

PASS=$(echo "ansible" | openssl passwd -1 -stdin)
useradd -p "$PASS" ansible
cat <<EOF > /etc/sudoers.d/ansible
ansible	ALL=NOPASSWD: ALL
EOF

cat <<EOF >> /etc/hosts
192.168.4.200 control.example.com control
192.168.4.201 ansible1.example.com ansible1
192.168.4.202 ansible2.example.com ansible2
192.168.4.203 ansible3.example.com ansible3
192.168.4.204 ansible4.example.com ansible4
EOF

su - ansible -c "ssh-keygen -b 2048 -t rsa -f /home/ansible/.ssh/id_rsa -q -P \"\""
su - ansible -c "ssh-keyscan ansible1.example.com 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible2.example.com 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible3.example.com 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible4.example.com 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible1 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible2 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible3 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan ansible4 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan control 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan control.example.com 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan  192.168.4.200 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan  192.168.4.201 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan  192.168.4.202 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan  192.168.4.203 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "ssh-keyscan  192.168.4.204 2>/dev/null >> /home/ansible/.ssh/known_hosts"
su - ansible -c "echo 'ansible' | sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible1.example.com"
su - ansible -c "echo 'ansible' | sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible2.example.com"
su - ansible -c "echo 'ansible' | sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible3.example.com"
su - ansible -c "echo 'ansible' | sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@ansible4.example.com"
su - ansible -c "echo 'ansible' | sshpass ssh-copy-id -f -i /home/ansible/.ssh/id_rsa.pub -o StrictHostKeyChecking=no ansible@control.example.com"


su - ansible -c "pip3 install ansible --user"
su - ansible -c "ansible --version"

su - ansible -c "mkdir -p /home/ansible/lab"

su - ansible -c "echo autocmd FileType yaml setlocal ai ts=2 sw=2 et > /home/ansible/.vimrc"

cat <<EOF > /home/ansible/lab/inventory
[control]
control.example.com

[centos]
ansible1.example.com
ansible2.example.com
ansible3.example.com

[ubuntu]
ansible4.example.com
EOF

su - ansible -c "git clone https://github.com/sandervanvugt/rhce8-live.git"
