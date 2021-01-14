Function New-AzureDNSRecord {
<#
.SYNOPSIS
    A simple function to manage Azure DNS with Powershell using the Az Powershell module.

.DESCRIPTION
    In order to use this script remember to specify the TenantId and the SubscriptionName, else the script wont load into your Azure tenant. 
    This function requires you to have created the DNS Zone and ressource group in advance, and 

.PARAMETER RecordType
    RecordType is required for letting this function know what record to create in Azure. Use Tab-completion to switch between the different RecordTypes.

.PARAMETER Name
    Name is required and is the identifier for what name the record is created as. Ex. if an A-record must be created, if you thn type "www" it will be created as "www.domain.com".

#>
[cmdletbinding()]
param(
[Parameter(Mandatory=$true)]
[ValidateSet('A','AAAA','CAA','CNAME','MX','NS','PTR','SOA','SRV','TXT')]
[string]$RecordType,

[Parameter(Mandatory=$true)]
[string]$Name
    )

# Declared Ressource group name, DNS Zone name and default TTL

$RGName = Get-AzDnsZone | Select-Object RessourceGroupName
$ZoneName = Get-AzDnsZone | Select-Object Name
$TTL = "360"
 
# Module installed check

if (Get-Module -ListAvailable -Name Az) {
        Write-Host "Az Powershell Module exists. Proceeding..."
} 
else {
    Install-Module -Name Az -AllowClobber
     }

# Connect to Azure tenant and create records

Connect-AzAccount -TenantId "1465daca-8f16-4a61-aaae-0ac42c0d2a54" -SubscriptionName "Betalt efter forbrug"

if($RecordType -eq "A") { 

    $IP = Read-Host "Specify the IP for the A record" 
           
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName -ResourceGroupName $RGName -Ttl $TTL -DnsRecords (New-AzDnsRecordConfig -IPv4Address $IP)
}

if($RecordType -eq "CNAME") {

    $CNAME = Read-Host "Specify the name for the destination of the CNAME"
    
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName -ResourceGroupName $RGName -Ttl $TTL -DnsRecords (New-AzDnsRecordConfig -Cname $CNAME)
}

if($RecordType -eq "SRV") {

    $Weight = Read-Host "Specify the weight for the SRV record"
    $Prio = Read-Host "Specify the priority for the SRV record"    
    $TCPPort = Read-Host "Specify the TCP port for the SRV record"
    $Target = Read-Host "Specify the target for the SRV record"
     
    New-AzDnsRecordSet -Name $Name -RecordType $RecordType -ZoneName $ZoneName -ResourceGroupName $RGName -Ttl $TTL -DnsRecords (New-AzDnsRecordConfig -Priority $Prio -Weight $Weight -Port $TCPPort -Target $Target)
    }
}