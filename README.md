# Some scripts
The intention with this repo is to put up useful scripts I've made :)

## dns.ps1
Updates a NameCheap hosted domain's dynamic DNS. 
Made for systems with multple network cards (and/or VPNs). 

You can choose which network card to use as base for your dynamic DNS, by specifying it. This eliminates the problem where other clients use another card's IP address, when you have more than one accessing the internet.
Set __$card__ to the name of the network card to use. You can update any subdomain, or the domain itself. The name is set in the varible __$d__. In the future it might be an idea to make that a parameter to the file :)

The script uses Namecheap's DNS server, instead of the local one your computer uses for browsing. This is to avoid the script thinking the IP is outdated due to an outdated DNS server, when it checks if the IP needs to be updated.

Run it every hour or so. It won't update the IP, if it's already up to date -so there's no need to worry about spamming the DDNS server.

Might work with other provides as well...
