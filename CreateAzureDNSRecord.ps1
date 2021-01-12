Function New-AzureDNSRecord {
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[ValidateSet('A','AAAA','CAA','CNAME','MX','NS','PTR','SOA','SRV','TXT')]
[string]$RecordType,

[Parameter(Mandatory=$true)]
[string]$Name
    )

#Connect-AzAccount -TenantId "e50f2ec7-cfc1-43f2-9aef-956fdbd5b860" -SubscriptionName "Infrastructure and Operations Production" 

if($RecordType -eq "A") { 

    $IP = Read-Host "Type the IP for the A record" 
           
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName-ResourceGroupName $RGName -Ttl $TTL -DnsRecords (New-AzDnsRecordConfig -IPv4Address $IP)
}

if($RecordType -eq "CNAME") {

    $CNAME = Read-Host "Type the name for the destination of the CNAME"
    
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName -ResourceGroupName $RGName -Ttl 360 -DnsRecords (New-AzDnsRecordConfig -Cname $CNAME)
}

if($RecordType -eq "SRV") {

    $Weight = Read-Host "Type the weight for the SRV record"
    $Prio = Read-Host "Type the priority for the SRV record"    
    $TCPPort = Read-Host "Type the TCP port for the SRV record"
    $Target = Read-Host "Type the target for the SRV record"
     
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName -ResourceGroupName $RGName -Ttl $TTL -DnsRecords (New-AzDnsRecordConfig -Priority $Prio -Weight $Weight -Port $TCPPort -Target $Target)
    }
}
Write-Host "Success! Use the New-AzureDNSRecord cmdlet to get started!"