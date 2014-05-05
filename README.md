  **BTC donations**: `1DzPaoarz8pCV8wMg96hAGYgW2coJd798K`

## What does it do
### remove-ssid-from-preferred-networks
Removes a SSID from the list of preferred networks.  
### remove-ssid-and-set-to-correct-network
Does the same as above, but then attempts to connect to a `desiredNetwork`.
### remove-all-except-desired-networks.sh
Removes all networks except the one you want.
## How it Works

## Requirements
0. For best results, the devices should be plugged in via Ethernet
1. Sometimes the remove-ssid-and-set-to-correct-network.sh can complete without a wired connection, but it is less-reliable

## Resources
0. [JAMF Nation Post]()

## Usage options
0. Change value of the `undesiredNetwork` variable to whatever SSID should be removed.
1. Change value of the `desiredNetwork` variable to whatever SSID is the preferred one.
