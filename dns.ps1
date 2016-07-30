# Namecheap.com Dynamic DNS updater for Windows with support for multiple network cards and VPN

# NameCheap's DDNS
$url = "dynamicdns.park-your-domain.com/update"
# Your domain, like "example.com"
$d = ""
# The API Key from the domain's DNS settings page on namecheap.com
$p =  ""
# Get the current IP from a specific network card, this avoids VPNs being used by accident and helps people with multiple network cards
$card = "Internet"
try {
	$ip = (Get-NetIPConfiguration -InterfaceAlias $card).IPv4Address.IPAddress
} catch {
	echo "Couldn't find your IP address! Maybe the card name is wrong?"
	exit
}
# Set the subdomain to update, eg @ for "domain.com" and www for "www.domain.com"
$rec = "@"

# Build a string with the full domain we're updating, this is used below for our DNS lookup
if ($rec -eq "@"){
    $h = "$d"
} else {
    $h = "$rec.$d"
}

try {
# Contact namecheap's own DNS and ask what our current IP is. If our own DNS isn't up-to-date, theirs should be!
	$curr = (Resolve-DnsName -Name $h -Type A -NoHostsFile -Server '72.20.53.50').IPAddress
} catch {
	echo "Couldn't resolve the current IP. Maybe it's a firewall issue?"
	exit
}

# Check if we need to update, or if the IP hasn't changed
if ($curr -eq $ip){
    echo "Up-to-date"
} else {
    echo "Updating from $curr to $ip"
    $res = Invoke-WebRequest -Uri "https://${url}?host=${rec}&domain=${d}&password=${p}&ip=${ip}"
    #$res
    # We get an XML back, so let's parse it
    $r = ([xml]$res.Content).'interface-response'
    if ($r.ErrCount -eq 0){
        echo "Updated! IP set to $($r.IP)"
    } else {
        # Loop through all returned errors and print them
        foreach ($e in $r.errors){
            echo "Error: $([string]$e.InnerText)"
        }
    }

   #echo "Result: ${res.StatusCode}"
}
