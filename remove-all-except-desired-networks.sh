#!/bin/bash
#----------AUTHOR------------
	# Jacob Salmela
	# 14 March 2014

#----------RESOURCES---------
	# Removes all SSIDs except one from the list of preferred networks

#---------DESCRIPTION--------
	# https://jamfnation.jamfsoftware.com/discussion.html?id=5327

#----------VARIABLES---------	
	# Enter desired and undesired SSIDs here
	desiredNetwork="Desired-SSID"

	# Determine if the interface is called Wi-Fi or Airport
	wifiOrAirport=$(networksetup -listallnetworkservices | grep -Ei '(Wi-Fi|AirPort)')

	# Determine what the device interface number is
	wirelessDevice=$(networksetup -listallhardwareports | awk "/$wifiOrAirport/,/Device/" | awk 'NR==2' | cut -d " " -f 2)

#----------FUNCTIONS---------
#####################################
function removeAllUndesiredNetworks() 
	{
	# For each network in the preferred list,
	for n in $(networksetup -listpreferredwirelessnetworks $wirelessDevice | awk '{print $1}')		
	do
		# If the $desiredNetwork is in thie list, do nothing
		if [ "$n" = "$desiredNetwork" ];then
			echo "$desiredNetwork will NOT be removed."
		# This is just to remove the function from trying to remove Preferred, which is just the column heading in the output of the command
		elif [ "$n" = "Preferred" ];then
			:
		# Otherwise, remove all the other networks
		else
			networksetup -removepreferredwirelessnetwork "$wirelessDevice" "$n"
		fi	
	done
	}

#----------------------------
#-----------SCRIPT-----------
#----------------------------
removeAllUndesiredNetworks
