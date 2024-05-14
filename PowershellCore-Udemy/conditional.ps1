## Step 1: Scaffold the command you need to run against each server
Get-Content -Path "\\servername\c$\App_configuration.txt"

## Since there are multiple servers involved, defining them in an array is always the best way
$servers = @('localhost','SRV2','SRV3','SRV4','SRV5')

## Now you can reference each element in the array instead of referencing different server name variables.
## This will come in handy when we loop later
Get-Content -Path "\\$($servers[0])\c$\App_configuration.txt"
Get-Content -Path "\\$($servers[1])\c$\App_configuration.txt"
Get-Content -Path "\\$($servers[2])\c$\App_configuration.txt"
Get-Content -Path "\\$($servers[3])\c$\App_configuration.txt"
Get-Content -Path "\\$($servers[4])\c$\App_configuration.txt"

## Come up with the code to handle the next requirement
Test-Connection -ComputerName 127.0.0.1 -Quiet -Count 1
Test-Connection -ComputerName 111.111.111.111 -Quiet -Count 1

## Quick intro to testing equality
1 –eq 1

1 -eq 2

1 -ne 2

if (1 -eq 1) {
	'Duh. 1 equals 1'
}

if (1 -eq 2) {
	'True'
} else {
	'Yep, not true'
}

if (Test-Connection -ComputerName $servers[0] -Quiet -Count 1) {
	Get-Content -Path "\\$($servers[0])\c$\App_configuration.txt"
} else {
	Write-Host "The server $($servers[0]) is offline!"
}

if (Test-Connection -ComputerName $servers[1] -Quiet -Count 1) {
	Get-Content -Path "\\$($servers[1])\c$\App_configuration.txt"
} else {
	Write-Host "The server $($servers[1]) is offline!"
}

if (Test-Connection -ComputerName $servers[1] -Quiet -Count 1) {
	Get-Content -Path "\\$($servers[1])\c$\App_configuration.txt"
} else {
	Write-Error "The server $($servers[1]) is offline!"
}

if (-not (Test-Connection -ComputerName $servers[1] -Quiet -Count 1)) {
	Write-Error "The server $($servers[1]) is offline!"
} else {
	Get-Content -Path "\\$($servers[1])\c$\App_configuration.txt"
}

## Account for two states
Test-Path "\\$($servers[0])\c$\App_configuration.txt"
Test-Path "\\$($servers[0])\c$\does not exist.txt"

if ((Test-Connection -ComputerName $servers[0] -Quiet -Count 1) -and (Test-Path "\\$($servers[0])\c$\App_configuration.txt")) {
	Get-Content -Path "\\$($servers[0])\c$\App_configuration.txt"
} else {
	Write-Error "The server $($servers[0]) is offline or the app configuration file doesn't exist!"
}

## Two states with an exclusion
$excludeThisServer = 'localhost'
if ($servers[0] -eq $excludeThisServer) {
    Write-Host "Excluding the $($servers[0]) server temporarily."
} elseif ((Test-Connection -ComputerName $servers[0] -Quiet -Count 1) -and (Test-Path "\\$($servers[0])\c$\App_configuration.txt")) {
	Get-Content -Path "\\$($servers[0])\c$\App_configuration.txt"
} else {
	Write-Error "The server $($servers[0]) is offline or the app configuration file doesn't exist!"
}

## The switch Statement

## Structure
switch (expression) {
    outputvalue {
        # Do something with code here.
    }
    outputvalue {
        # Do something with code here.
    }
    default {
        # Stuff to do if no matches were found
    }
}

$currentServer = $servers[0]
switch ($currentServer) {
    'localhost' {
        Write-Host "The current server value is $_"
        break
    }
    'SRV1' {
        Write-Host "The current server value is $_"
        break
    }
    'SRV2' {
        Write-Host "The current server value is $_"
        break
    }
    default {
        Write-Host "No matches found for the current server $_"
    }
}


switch (1) {
    1 {
        Write-Host "The number is $_"
    }
    2 {
        Write-Host "The number is $_"
    }
    1 {
        Write-Host "The number is $_"
    }
    default {
        Write-Host "No number matches for $_"
    }
}