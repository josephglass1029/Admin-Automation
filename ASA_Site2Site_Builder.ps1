$peer1wan = Read-Host -Prompt 'Input Site 1 Public IP address:'
$peer1siteprefix = Read-Host -Prompt 'Input the 3 Letter Site Prefix for Site 1'
$peer1siteid = Read-Host -Prompt 'Input the Site ID for Side 1:'
$subnetmask = "255.255.248.0"
$peer1vlan1 = "$peer1siteprefix-10.$peer1siteid.0.0"
$peer1vlan2 = "$peer1siteprefix-10.$peer1siteid.40.0"
$peer1vlan3 = "$peer1siteprefix-10.$peer1siteid.120.0"
$peer1vlan4 = "$peer1siteprefix-10.$peer1siteid.160.0"
$peer1vlangroup = "$peer1siteprefix-10.$peer1siteid.0.0"
$peer2wan = Read-Host -Prompt 'Input Site 2 Public IP address:'
$peer2siteprefix = Read-Host -Prompt 'Input the 3 Letter Site Prefix for Site 2'
$peer2siteid = Read-Host -Prompt 'Input the Site ID for Side 2:'
$peer2vlan1 = "$peer2siteprefix-10.$peer2siteid.0.0"
$peer2vlan2 = "$peer2siteprefix-10.$peer2siteid.40.0"
$peer2vlan3 = "$peer2siteprefix-10.$peer2siteid.120.0"
$peer2vlan4 = "$peer2siteprefix-10.$peer2siteid.160.0"
$peer2vlangroup = "$peer2siteprefix-10.$peer2siteid.0.0"
$grouppolicy = "GroupPolicy_NWC"
$presharekey = Read-Host -Prompt 'Input the Pre Shared Key to be used'
$peer1accesslistname = "CRYPTOMAP_$peer1siteprefix$peer2siteprefix"
$peer2accesslistname = "CRYPTOMAP_$peer2siteprefix$peer1siteprefix"

Write-Host "Create ASA1 Configuration"
Write-Host "object network" ($peer1siteprefix + '-10.' + $peer1siteid + '.0.0_21')
Write-Host "subnet 10.$peer1siteid.0.0 $subnetmask"
Write-Host "object network" ($peer1siteprefix + '-10.' + $peer1siteid + '.40.0_21')
Write-Host "subnet 10.$peer1siteid.40.0 $subnetmask"
Write-Host "object network" ($peer1siteprefix + '-10.' + $peer1siteid + '.120.0_21')
Write-Host "subnet 10.$peer1siteid.120.0 $subnetmask"
Write-Host "object network" ($peer1siteprefix + '-10.' + $peer1siteid + '.160.0_21')
Write-Host "subnet 10.$peer1siteid.160.0 $subnetmask"
Write-Host "exit"
Write-Host "object-group network $peer2vlangroup"
Write-Host "network object" ($peer1vlan1 + '_21')
Write-Host "network object" ($peer1vlan2 + '_21')
Write-Host "network object" ($peer1vlan3 + '_21')
Write-Host "network object" ($peer1vlan4 + '_21')
Write-Host "exit"
Write-Host "access-list $peer2accesslistname extended permit ip object-group $peer2vlangroup object-group $peer1vlangroup"
Write-Host "nat (any,outside) source static $peer2vlangroup $peer2vlangroup destination static $peer1vlangroup $peer1vlangroup"
Write-Host "crypto map outside_map $peer1siteid match address $peer2accesslistname"
Write-Host "crypto map outside_map $peer1siteid set peer $peer1wan"
Write-Host "crypto map outside_map $peer1siteid set ikev1 transform-set ESP-AES-256-SHA"
Write-Host "exit"
Write-Host "$grouppolicy internal"
Write-Host "$grouppolicy attributes"
Write-Host "vpn-tunnel-protocol ikev1"
Write-Host "exit"
Write-Host "tunnel-group $peer1wan type ipsec-l2l"
Write-Host "tunnel-group $peer1wan general-attributes"
Write-Host "default-group-policy $grouppolicy"
Write-Host "tunnel-group $peer1wan ipsec-attributes"
Write-Host "ikev1 pre-share $presharekey"
Write-Host "exit"

Write-Host "Create ASA2 Configuration"
Write-Host "object network" ($peer2siteprefix + '-10.' + $peer2siteid + '.0.0_21')
Write-Host "subnet 10.$peer2siteid.0.0 $subnetmask"
Write-Host "object network" ($peer2siteprefix + '-10.' + $peer2siteid + '.40.0_21')
Write-Host "subnet 10.$peer2siteid.40.0 $subnetmask"
Write-Host "object network" ($peer2siteprefix + '-10.' + $peer2siteid + '.120.0_21')
Write-Host "subnet 10.$peer2siteid.120.0 $subnetmask"
Write-Host "object network" ($peer2siteprefix + '-10.' + $peer2siteid + '.160.0_21')
Write-Host "subnet 10.$peer2siteid.160.0 $subnetmask"
Write-Host "exit"
Write-Host "object-group network $peer2vlangroup"
Write-Host "network object" ($peer2vlan1 + '_21')
Write-Host "network object" ($peer2vlan2 + '_21')
Write-Host "network object" ($peer2vlan3 + '_21')
Write-Host "network object" ($peer2vlan4 + '_21')
Write-Host "exit"
Write-Host "access-list $peer1accesslistname extended permit ip object-group $peer1vlangroup object-group $peer2vlangroup"
Write-Host "nat (any,outside) source static $peer1vlangroup $peer1vlangroup destination static $peer2vlangroup $peer2vlangroup"
Write-Host "crypto map outside_map $peer2siteid match address $peer2accesslistname"
Write-Host "crypto map outside_map $peer2siteid set peer $peer1wan"
Write-Host "crypto map outside_map $peer2siteid set ikev1 transform-set ESP-AES-256-SHA"
Write-Host "exit"
Write-Host "$grouppolicy internal"
Write-Host "$grouppolicy attributes"
Write-Host "vpn-tunnel-protocol ikev1"
Write-Host "exit"
Write-Host "tunnel-group $peer2wan type ipsec-l2l"
Write-Host "tunnel-group $peer2wan general-attributes"
Write-Host "default-group-policy $grouppolicy"
Write-Host "tunnel-group $peer2wan ipsec-attributes"
Write-Host "ikev1 pre-share $presharekey"
Write-Host "exit"