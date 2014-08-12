#VM writeback timeout
 	echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs';
#Enable SATA link power Managmenet for host0
 	echo 'min_power' > '/sys/class/scsi_host/host0/link_power_management_policy';
#Enable SATA link power Managmenet for host1
 	echo 'min_power' > '/sys/class/scsi_host/host1/link_power_management_policy';
#Enable SATA link power Managmenet for host2
 	echo 'min_power' > '/sys/class/scsi_host/host2/link_power_management_policy';
#Enable SATA link power Managmenet for host3
 	echo 'min_power' > '/sys/class/scsi_host/host3/link_power_management_policy';
#Enable SATA link power Managmenet for host4
 	echo 'min_power' > '/sys/class/scsi_host/host4/link_power_management_policy';
#Enable SATA link power Managmenet for host5
 	echo 'min_power' > '/sys/class/scsi_host/host5/link_power_management_policy';
#Enable Audio codec power management
 	echo '1' > '/sys/module/snd_hda_intel/parameters/power_save';
#NMI watchdog should be turned off
 	echo '0' > '/proc/sys/kernel/nmi_watchdog';
#Autosuspend for USB device Bluetooth USB Host Controller [Atheros Communications]
 	echo 'auto' > '/sys/bus/usb/devices/2-1.6/power/control';
#Autosuspend for unknown USB device 1-1.1 (138a:003d)
 	echo 'auto' > '/sys/bus/usb/devices/1-1.1/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1a.0/power/control';
#Runtime PM for PCI Device Intel Corporation 3rd Gen Core processor DRAM Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:00.0/power/control';
#Runtime PM for PCI Device Intel Corporation 3rd Gen Core processor Graphics Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:02.0/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:16.0/power/control';
#Runtime PM for PCI Device JMicron Technology Corp. Standard SD Host Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:02:00.2/power/control';
#Runtime PM for PCI Device JMicron Technology Corp. MS Host Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:02:00.3/power/control';
#Runtime PM for PCI Device JMicron Technology Corp. SD/MMC Host Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:02:00.0/power/control';
#Runtime PM for PCI Device Qualcomm Atheros AR9485 Wireless Network Adapter
 	echo 'auto' > '/sys/bus/pci/devices/0000:03:00.0/power/control';
#Runtime PM for PCI Device Intel Corporation HM76 Express Chipset LPC Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.0/power/control';
#Runtime PM for PCI Device Realtek Semiconductor Co., Ltd. RTL8111/8168 PCI Express Gigabit Ethernet controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:04:00.0/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1d.0/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.5/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 3
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.2/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 4
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.3/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1c.0/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1b.0/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode]
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:1f.2/power/control';
#Runtime PM for PCI Device Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller
 	echo 'auto' > '/sys/bus/pci/devices/0000:00:14.0/power/control';
#Wake-on-lan status for device enp4s0
 	ethtool -s enp4s0 wol d;
