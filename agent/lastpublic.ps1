# Plugin "Get IP" OCSInventory
# Author CARNET
# Original : Valentin COSSE & Valentin DEVILLE

$ripeOrg     = [String]::Empty;
$ripeNetName = [String]::Empty;

$getIPUri = "http://bwm4.carnet.hr:8080/live/ip.php";
# $getIPUri = "https://api.ipify.org?format=text";

$ip = Invoke-RestMethod -Uri $getIPUri;
$ripeWhois = (Invoke-RestMethod -Uri "https://stat.ripe.net/data/whois/data.json?resource=$ip").data.records;

for ($ripeKey=0; $ripeKey -le $ripeWhois.value.Count; $ripeKey++) {
    if ($ripeWhois.key[$ripeKey] -eq "descr") {
        $ripeOrg += $ripeWhois.value[$ripeKey] +", ";
    }
    elseif ($ripeWhois.key[$ripeKey] -eq "netname") {
        $ripeNetName += $ripeWhois.value[$ripeKey] +", ";
    }
}

$ripeOrg     = $ripeOrg.TrimEnd();
$ripeNetName = $ripeNetName.TrimEnd();

if ($ripeOrg.Length -gt 0) { if ($ripeOrg.Substring($ripeOrg.Length-1,1) -eq ",") { $ripeOrg = $ripeOrg.Substring(0,$ripeOrg.Length-1) } }
if ($ripeNetName -gt 0) { if ($ripeNetName.Substring($ripeNetName.Length-1,1) -eq ",") { $ripeNetName = $ripeNetName.Substring(0,$ripeNetName.Length-1) } }

$xml = '<LASTPUBLICIP>'
$xml += '<IP>' + $ip + '</IP>'
$xml += '<CITY>' + $ripeNetName + '</CITY>'
$xml += '<ORG>' + $ripeOrg + '</ORG>'
$xml += '</LASTPUBLICIP>'

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;
[Console]::WriteLine($xml);