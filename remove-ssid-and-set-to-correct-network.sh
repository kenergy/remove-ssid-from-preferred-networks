#!/bin/bash
#----------AUTHOR------------
	# Jacob Salmela
	# 24 April 2013
	
#----------RESOURCES---------
	# Removes a SSID from the list of preferred networks and connected to a different, desired network
	
#---------DESCRIPTION--------
	# https://jamfnation.jamfsoftware.com/discussion.html?id=5327

#----------VARIABLES---------	
	# Enter desired and undesired SSIDs here
	undesiredNetwork="Undesired-SSID"
	desiredNetwork="Desired-SSID"

	# Determine if the interface is called Wi-Fi or Airport
	wifiOrAirport=$(networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)')

	# Determine what the device interface number is
	wirelessDevice=$(networksetup -listallhardwareports | awk "/$wifiOrAirport/,/Device/" | awk 'NR==2' | cut -d " " -f 2)

	# Determine what wireless network the computer is currently connected to
	currentNetwork=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep ' SSID:' | cut -d ':' -f 2 | tr -d ' ')

	# Testing if the guest SSID is in the list of preferred networks
	guestExists=$(/usr/sbin/networksetup -listpreferredwirelessnetworks en1 | awk '/Guest-Network/ {print $1}')
	}
	
#----------FUNCTIONS---------
#########################################
function removeUndesiredConnectToDesired() 
	{
	echo -e "Wireless interface name:\t\t$wifiOrAirport"
	echo -e "Wireless interface number:\t\t$wirelessDevice"
	echo -e "CURRENT NETWORK:\t\t$currentNetwork"
	
	# Remove the guest SSID from the list of preferred networks
	networksetup -removepreferredwirelessnetwork "$wirelessDevice" "$guestExists"
	
	# Turn the wireless off so it disconnects from the undesireable network
	networksetup -setairportpower $wirelessDevice off
	
	# Clear the DNS settings
	networksetup -setdnsservers "$wifiOrAirport" "empty"
	
	# Turn the wireless back on so it will connect to a different preferred network
	networksetup -setairportpower $wirelessDevice on
	
	# Sleep for a while to allow the device to connect, get an IP, etc.
	sleep 25
	
	# Create a variable to store what network the device is now connected to
	currentNetworkAfterGuestIsRemoved=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep ' SSID:' | cut -d ':' -f 2 | tr -d ' ')
	
	# echo this information to the user
	echo -e "NEW NETWORK:\t\t$currentNetworkAfterGuestIsRemoved"
	}

##############################
function setToCorrectNetwork()
	{
	case $currentNetwork in
		$undesiredNetwork) networksetup -setairportnetwork "$wirelessDevice" "$desiredNetwork";
						removeUndesiredConnectToDesired;;
		$desiredNetwork) networksetup -removepreferredwirelessnetwork "$wirelessDevice" "$undesiredNetwork";;
		*) echo "Something went wrong.";;
	esac
	}

#----------------------------
#-----------SCRIPT-----------
#----------------------------
setToCorrectNetwork
