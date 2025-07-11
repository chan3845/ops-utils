#!/bin/bash

# Variables
ZABBIX_SERVER="zabbix.example.com or ip_address" ## Replace with your Zabbix server's FQDN or IP
AGENT_VERSION="7.0"  # Specify the desired agent version
HOSTNAME=$(hostname)

# Determine OS and version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo "Unsupported OS."
    exit 1
fi



# Function to exclude Zabbix packages from EPEL
exclude_zabbix_from_epel() {
    if [ -f /etc/yum.repos.d/epel.repo ]; then
        echo "EPEL repository found."
        dnf config-manager --save --setopt=epel.excludepkgs=zabbix*
        echo "Zabbix repo exclusion added successfully."

    else
        echo "EPEL repository is not installed. Installing.."
        dnf install epel-release -y
        dnf config-manager --save --setopt=epel.excludepkgs=zabbix*
        echo "Zabbix repo exclusion added successfully."
    fi
}

# Install Zabbix agent based on OS
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    wget https://repo.zabbix.com/zabbix/$AGENT_VERSION/$OS/pool/main/z/zabbix-release/zabbix-release_latest_$AGENT_VERSION+${OS}${VER}_all.deb
    dpkg -i zabbix-release_latest_$AGENT_VERSION+${OS}${VER}_all.deb
    apt update
    apt install -y zabbix-agent

elif [[ "$OS" == "centos" || "$OS" == "oracle" || "$OS" == "rhel" || "$OS" == "rocky" ]]; then
    exclude_zabbix_from_epel
    VER=${VER%.*}  # Convert VER to integer if needed
    echo "Installing zabbix repo..."
    rpm -Uvh https://repo.zabbix.com/zabbix/$AGENT_VERSION/$OS/$VER/x86_64/zabbix-release-latest-$AGENT_VERSION.el$VER.noarch.rpm
    yum clean all
    yum install -y zabbix-agent
    sudo firewall-cmd --permanent --add-port=10050/tcp
    sudo firewall-cmd --reload
else
    echo "Unsupported OS."
    exit 1
fi

# Configure Zabbix agent
sed -i "s/^Server=.*/Server=$ZABBIX_SERVER/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive=.*/ServerActive=$ZABBIX_SERVER/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=.*/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf

# Uncomment the following line to perform auto agent registration 
sed -i 's/^\s*#\s*HostMetadata.*/HostMetadata=linux/' /etc/zabbix/zabbix_agentd.conf

# Start and enable Zabbix agent service
systemctl restart zabbix-agent
systemctl enable zabbix-agent

echo "Zabbix agent installation and configuration completed."

