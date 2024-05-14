
# Logging Function
function Write-Log {
	[CmdletBinding()]
	param()
	$timeGenerated = Get-Date -Format HH:mm:ss
	Add-Content -Path "C:\Scripts\software_installer.log" -Value "$timeGenerated - Starting install..."
}

Add-Content -Path "C:\Scripts\software_installer.log" -Value "$timeGenerated - Starting install..."
Start-Process -FilePath 'installer.exe' -ArgumentList '/i /s' -Wait -NoNewWindow
Add-Content -Path "C:\Scripts\software_installer.log" -Value "$timeGenerated - Finished install."

# Function with Parameters
function Write-Log {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[string]$LogMessage,

		[Parameter()]
		[ValidateScript({ Test-Path -Path $_ })]
		[string]$LogFilePath = 'C:\Scripts\software_installer.log'
	)
	$timeGenerated = Get-Date -Format HH:mm:ss
	Add-Content -Path $LogFilePath -Value "$timeGenerated - $LogMessage"
}

# Adding Pipeline Support
@(
	[pscustomobject]@{'ComputerName' = 'SRV1'; 'Version' = 1}
	[pscustomobject]@{'ComputerName' = 'SRV2'; 'Version' = 2}
	[pscustomobject]@{'ComputerName' = 'SRV3'; 'Version' = 2}
) | Export-Csv -Path C:\Scripts\software_installs.csv -Append

function Install-Software {
	param(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateSet(1,2)]
		[int]$Version,

		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[string]$ComputerName
	)
	begin {}
	process {
		Write-Host "I installed software version $Version on $ComputerName. Yippee!"
	}
	end {}
}

Import-Csv -Path C:\Scripts\software_installs.csv | Install-Software


# Adding Help Content
function Install-Software {
	<#
    .SYNOPSIS
			Installs software on a specified computer matching a specific version.
    
    .PARAMETER Version
        An integer value with allowed values of 1 and 2 that represents the version of the software
				to install.

		.PARAMETER ComputerName
				A string value representing the name of the computer to install the software on.

    .EXAMPLE
        PS> Install-Software -ComputerName PC1 -Version 1

				This example installs software version 1 on the PC1 computer. 

	#>
	param(
		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[ValidateSet(1,2)]
		[int]$Version,

		[Parameter(Mandatory,ValueFromPipelineByPropertyName)]
		[string]$ComputerName
	)
	begin {}
	process {
		Write-Host "I installed software version $Version on $ComputerName. Yippee!"
	}
	end {}
}