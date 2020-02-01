#!/bin/bash

__create_user() {
# Create a user to SSH into as.

useradd ansible

SSH_USERPASS=ansible

echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin ansible)
echo ssh user password: $SSH_USERPASS

cat <<EOF > /etc/sudoers.d/ansible
ansible	ALL=NOPASSWD: ALL
EOF

}

# Call all functions
__create_user

