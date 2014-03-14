#!/bin/bash
#----------AUTHOR------------
	# Jacob Salmela
	# 28 November 2012

#----------RESOURCES---------
	# https://jamfnation.jamfsoftware.com/discussion.html?id=5327

#---------DESCRIPTION--------
	# Connects to a guest network to run Recon, which downloads a WiFi config profile.  
	# Then connects the the secure network via the profile and removes the guest network from the preferred list
	# Works best if run locally
	
#----------VARIABLES---------	
	# Entered the SSID used to run Recon in the quotes below
	guestNetwork="Guest-SSID"
	
	# Entered preferred SSID in the quotes below
	desiredNetwork="Desired-SSID"
	
	# Enter the SSID to be removed once the desired network is working in the quotes below
	undesiredNetwork="Undesired-SSID"
	
	# Determine if the interface is called Wi-Fi or Airport
	wifiOrAirport=$(networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)')

	# Determine what the device interface number is
	wirelessDevice=$(networksetup -listallhardwareports | awk "/$wifiOrAirport/,/Device/" | awk 'NR==2' | cut -d " " -f 2)
	
	# Current SSID connected to
	currentNetwork=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep ' SSID:' | cut -d ':' -f 2 | tr -d ' ')

#----------FUNCTIONS---------
####################################
function connectToGuestAndRunRecon()
	{ 
	# If the current SSID is null (no WiFi network connected) OR the current network is not the desired network, then
	if [ -z $currentNetwork ] || [ $currentNetwork != $desiredNetwork ];then
		
		# Turn the wireless off so it disconnects from the undesirable network
		networksetup -setairportpower $wirelessDevice off

		# Turn the wireless back on so it will connect to a guest network in order to run Recon
		networksetup -setairportpower $wirelessDevice on
	
		# Connect to guest network
		networksetup -setairportnetwork "$wirelessDevice" "$guestNetwork"
		
		# Sleep for a while to allow the device to connect, get an IP, etc (adjust as needed)
		sleep 15
	
		# Run Recon to get the profile back
		jamf recon
		
	else
		# Do nothing
		:
	fi
	}
	
###################################################
function deleteGuestAndConnectToEnterpriseNetwork()
	{ 
	# Turn the wireless off so it disconnects from the guest network
	networksetup -setairportpower $wirelessDevice off
	
	# Remove the guest SSID from the list of preferred networks
	networksetup -removepreferredwirelessnetwork "$wirelessDevice" "$guestNetwork"

	# Turn the wireless back on so it will connect to a guest network in order to run Recon
	networksetup -setairportpower $wirelessDevice on
	
	# Clear the DNS settings (is this needed...?)
	#networksetup -setdnsservers "$wifiOrAirport" "empty"
	
	# Connect to guest network
	networksetup -setairportnetwork "$wirelessDevice" "$desiredNetwork"
		
	# Sleep for a while to allow the device to connect, get an IP, etc (adjust as needed)
	sleep 15
	}
	
#----------------------------
#-----------SCRIPT-----------
#----------------------------
connectToGuestAndRunRecon
deleteGuestAndConnectToEnterpriseNetwork
