## recall what a scriptblock is
$scriptBlock = { Write-Host 'Hello, I am in a scriptblock' }

## Run locally - just executing the code in the scriptblock on the local machine
& $scriptBlock

## Invoke-Command will run scriptblocks locally too
Invoke-Command -ScriptBlock {'Hello, I am in a scriptblock invoked with Invoke-Command!'}

## scriptblocks are "portable" using Invoke-Command
Invoke-Command -ScriptBlock {'Hello, I am in a scriptblock invoked with Invoke-Command!'}

## the power comes with you add the ComputerName or HostName parameter
Invoke-Command -ScriptBlock {'Hello, I am in a scriptblock invoked with Invoke-Command!'} -ComputerName SOMEREMOTEMACHINE


# PS REMOTING

Invoke-Command -ComputerName SRV2 -ScriptBlock {Write-Host "Hi, I'm running code on the $(hostname) remote computer!"}

Get-LocalGroupMember -Group 'Remote Management Users'

Add-LocalGroupMember -Group 'Remote Management Users' -Member user
Get-LocalGroupMember -Group 'Remote Management Users'

Invoke-Command -ComputerName SRV2 -ScriptBlock {Write-Host "Hi, I'm running code on the $(hostname) remote computer!"}

$scriptblock = { Set-Content -Path 'somefile.txt' -Value '' }
Invoke-Command -Scriptblock $scriptblock -ComputerName SRV2

icm -ComputerName SRV2 -ScriptBlock {get-item somefile.txt} | select name,creationtime

$scriptContents = 
@'
Write-Host "Deleting the file just created..."
Remove-Item -Path somefile.txt
'@

Set-Content -Path 'RunThisRemotely.ps1' -Value $scriptContents

Get-Content RunThisRemotely.ps1

Invoke-Command -ComputerName SRV2 -FilePath RunThisRemotely.ps1

icm -ComputerName SRV2 -ScriptBlock {Test-Path somefile.txt}

$registryKeyPaths = @(
    'HKLM:\SOFTWARE\Microsoft\AppV\',
    'HKLM:\SOFTWARE\Microsoft\AccountsControl\'
)

$localScriptBlock = {
    ## Check to see if the registry keys exist on the computer
    foreach ($path in $registryKeyPaths) {
        if (Test-Path -Path $path) {
            Write-Host -Object "The registry path [$path] exists on the computer $(hostname)."
        } else {
            Write-Host -Object "The registry path [$path] does not exist on the computer $(hostname)."
        }
    }
}

Invoke-Command -ScriptBlock $localScriptBlock

$remoteScriptBlock = {
    ## Check to see if the registry keys exist on the computer
    foreach ($path in $using:registryKeypaths) {
        if (Test-Path -Path $path) {
            Write-Host -Object "The registry path [$path] exists on the computer $(hostname)."
        } else {
            Write-Host -Object "The registry path [$path] does not exist on the computer $(hostname)."
        }
    }
}

Invoke-Command -ScriptBlock $remoteScriptBlock -ComputerName SRV2

$remoteScriptBlock = {
    ## Check to see if the registry keys exist on the computer
    foreach ($path in $args) {
        if (Test-Path -Path $path) {
            Write-Host -Object "The registry path [$path] exists on the computer $(hostname)."
        } else {
            Write-Host -Object "The registry path [$path] does not exist on the computer $(hostname)."
        }
    }
}

Invoke-Command -ScriptBlock $remoteScriptBlock -ComputerName SRV2 -ArgumentList $registryKeyPaths

# BUILDING WITH REUSABLE SESSION

Get-CimInstance -ClassName Win32_LogicalDisk

Get-CimInstance -ClassName Win32_LogicalDisk| Measure-Object -Property 'FreeSpace' -Sum

(Get-CimInstance -ClassName Win32_LogicalDisk| Measure-Object -Property 'FreeSpace' -Sum).Sum

$totalFreeSpaceInBytes = (Get-CimInstance -ClassName Win32_LogicalDisk| Measure-Object -Property 'FreeSpace' -Sum).Sum
$totalFreeSpaceGb = $totalFreeSpaceInBytes / 1GB
$totalFreeSpaceGb

$totalFreeSpaceGb = [math]::Round($totalFreeSpaceGb,2)
$totalFreeSpaceGb

[math]::

function Get-WmiObjectValue {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$PropertyName,
		
		[Parameter(Mandatory)]
		[string]$WmiClassName
		
	)
	
	$number = (Get-CimInstance -ClassName $WmiClassName | Measure-Object -Property $PropertyName -Sum).Sum
	$numberGb = $number / 1GB
	[math]::Round($numberGb,2)
}

$totalFreeSpaceGb = Get-WmiObjectValue -WmiClassName Win32_PhysicalMemory -PropertyName Capacity
$totalFreeSpaceGb

$totalMemoryGb = Get-WmiObjectValue -WmiClassName Win32_LogicalDisk -PropertyName FreeSpace
$totalMemoryGb


# REUSABLE SESSIONS IN REAL WORLD
function Get-WmiObjectValue {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$PropertyName,
		
		[Parameter(Mandatory)]
		[string]$WmiClassName,

		[Parameter(Mandatory)]
		[System.Management.Automation.Runspaces.PSSession]$Session
		
	)

	$scriptBlock = {
		$number = (Get-CimInstance -ClassName $using:WmiClassName | Measure-Object -Property $using:PropertyName -Sum).Sum
		$numberGb = $number / 1GB
		[math]::Round($numberGb,2)
	}
	Invoke-Command -Session $Session -Scriptblock $scriptBlock
}

## Grab the alternate credential so that Get-CimInstance will work on the remote computer
$adminCred = Get-Credential -UserName adam

## Create a session authenticating as the adam user
$session = New-PSSession -ComputerName SRV2 -Credential $adminCred

## Find the total memory and total volume storage space on the remote computer
$totalMemoryGb = Get-WmiObjectValue -PropertyName Capacity -WmiClassName Win32_PhysicalMemory -Session $session
$totalStorageGb = Get-WmiObjectValue -PropertyName FreeSpace -WmiClassName Win32_LogicalDisk -Session $session

Write-Host "The computer $($session.ComputerName) has $totalMemoryGb GB of memory and $totalStorageGb GB of free space across all volumes."

## Remove the shared session
Remove-PSSession -Session $session

# HOW TO HANDLE PSSESSION
Enter-PSSession -ComputerName SRV2

Get-PSSession

$session = New-PSSession -ComputerName SRV2

Enter-PSSession -Session $session


exit
Get-PSSession

Invoke-Command -Session $session -ScriptBlock {'Yay! I am in the remote computer!'}

Disconnect-PSSession -Session $session

Connect-PSSession -ComputerName SRV2

Get-PSSession | Remove-PSSession