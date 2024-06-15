#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error

username="IEUser"
password="Passw0rd!"

# Create unique name for vm
vm_name="temp_win$(date +%Y%m%d-%H%M)"

# Path to MSEdge - Windows 10 OVA file
tempwindow_path="$HOME/VirtualBox VMs/MSEdge - Win10.ova"

# Select a random port number for remote desktop between 25000 to 30000
# Or get specific port from first parameter
port_number=${1:-$(shuf -i 25000-30000 -n 1)}

# import VM from the path
vboxmanage import "$tempwindow_path" --vsys 0 --vmname $vm_name

# Add port forwarding for remote desktop
VBoxManage modifyvm $vm_name --natpf1 "remote,tcp,,$port_number,,3389"

# Start the VM in headless
VBoxManage startvm --type headless $vm_name

# Connect to remote desktop
xfreerdp /v:localhost:$port_number /u:$username /p:$password /f /dynamic-resolution /cert:tofu

