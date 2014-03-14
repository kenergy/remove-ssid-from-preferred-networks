#!/bin/bash
#----------AUTHOR------------
	# Jacob Salmela
	# 26 November 2012

#----------RESOURCES---------
	# Removes a SSID from the list of preferred networks

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

#----------FUNCTIONS---------
#################################
function removeUndesiredNetwork() 
	{
	case $(networksetup -listpreferredwirelessnetworks $wirelessDevice | awk '/'"$undesiredNetwork"'/ {print $1}') in
		"$undesiredNetwork") networksetup -removepreferredwirelessnetwork "$wirelessDevice" "$undesiredNetwork";
							return 0;;
		*) echo "$undesiredNetwork is NOT in the preferred list.";
							return 1;;
	esac
	}

#----------------------------
#-----------SCRIPT-----------
#----------------------------
removeUndesiredNetwork
