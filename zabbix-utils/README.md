# 🖥️ Zabbix Agent Installer Script

This is a **bash script** to install and configure the **Zabbix Agent (v7.0)** automatically on various Linux distributions. It supports Debian-based and RHEL-based systems and ensures proper repository setup, firewall configuration, and agent registration with the Zabbix server.

---

## 📌 Supported Distributions

- Ubuntu
- Debian
- CentOS
- RHEL
- Oracle Linux
- Rocky Linux

---

## ⚙️ What This Script Does

- Detects your Linux distribution and version.
- Downloads and installs the appropriate Zabbix repository and agent package.
- Configures the Zabbix agent to communicate with your Zabbix server.
- Opens the required firewall port (`10050/tcp`) for Zabbix agent.
- Enables auto-registration (optional, via `HostMetadata`).
- Starts and enables the Zabbix agent service.

---

## 🛠️ Usage

### 1. Clone the repository

```bash
git clone https://github.com/your-username/zabbix-agent-installer.git
cd zabbix-agent-installer
```

### 2. Edit the script
Open the script in a text editor and set your Zabbix server address:

```bash
ZABBIX_SERVER="your-zabbix-server-ip-or-hostname"
```

### 3. Run the script with root or sudo privileges
```bash
sudo ./zabbix_agent_installer.sh
```

### 4. HostMetadata (Optional)
This script includes the following line to enable HostMetadata for auto-registration:
```bash
sed -i 's/^\s*#\s*HostMetadata.*/HostMetadata=linux/' /etc/zabbix/zabbix_agentd.conf
```
- By default, it sets HostMetadata=linux.
- You can change or disable it as needed.
```

## 📝 Notes
Tested with Zabbix 7.0
You can customize agent config further in /etc/zabbix/zabbix_agentd.conf

## 🙋‍♂️ Contribution
Feel free to open issues or submit pull requests to support more OS types, improve error handling, or add features.

