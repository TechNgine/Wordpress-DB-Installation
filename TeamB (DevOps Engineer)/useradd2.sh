#!/bin/bash

# Define the users to be managed
users=("ola" "dennis" "teama" "teamb")

# Loop over each user
for user in "${users[@]}"; do
    # Check if the user exists
    if id "$user" &>/dev/null; then
        echo "User $user already exists."
    else
        # Create user with home directory and default bash shell
        sudo useradd -m -s /bin/bash "$user"
        # Set the password as the username
        echo "$user:$user" | sudo chpasswd
        # Add user to the sudo group
        sudo usermod -aG sudo "$user"
        # Give user passwordless sudo access
        sudo bash -c "echo '$user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$user"
        echo "User $user created and configured successfully."
    fi
done

# Check if PasswordAuthentication is already enabled before modifying the SSH configuration
ssh_config_file="/etc/ssh/sshd_config.d/60-cloudimg-settings.conf"
if grep -q "^PasswordAuthentication yes" "$ssh_config_file"; then
    echo "PasswordAuthentication is already enabled."
else
    sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' "$ssh_config_file"
    sudo systemctl restart ssh
    echo "PasswordAuthentication enabled and SSH service restarted."
fi

