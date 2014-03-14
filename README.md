  **BTC donations**: `1NANWvtGH8u3bzwT17DgYfBqxbjjuQZKrx`

  **LTC donations**: `LWpc6xfL2W9CH9Qse7Pci6CEvuSQUyEyD6`
## What does it do
### remove-ssid-from-preferred-networks
Removes a SSID from the list of preferred networks.  
### remove-ssid-and-set-to-correct-network
Does the same as above, but then attempts to connect to a `desiredNetwork`
## How it Works

## Requirements
0. For best results, the devices should be plugged in via Ethernet
1. Sometimes the remove-ssid-and-set-to-correct-network.sh can complete without a wired connection, but it is less-reliable

## Resources
0. [JAMF Nation Post]()

## Usage options
0. Change value of the `undesiredNetwork` variable to whatever SSID should be removed.
1. Change value of the `desiredNetwork` variable to whatever SSID is the preferred one.
