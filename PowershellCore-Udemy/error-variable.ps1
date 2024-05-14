param (
	[Parameter(Mandatory)]
	[string]$FolderPath,
	
	[Parameter(Mandatory)]
	[int]$DaysOld
)

$Now = Get-Date
$LastWrite = $Now.AddDays(-$DaysOld)
$oldFiles = (Get-ChildItem -Path $FolderPath -File -Recurse).Where{$_.LastWriteTime -le $LastWrite}

foreach ($file in $oldFiles) {
	try {
		Remove-Item -Path $file.FullName -ErrorAction Stop
		Write-Verbose -Message "Successfully removed [$($file.FullName)]."
       # BELOW IS THE ERROR VARIABLE BEING CATCH
	} catch [System.IO.IOException] {
		Write-Warning "The file $($file.FullName) could not be removed because it's probably read only."
		$setWritable = Read-Host 'Would you like to attempt to remove the read-only attribute? (Y,N)'
		if ($setWritable -eq 'Y') {
			Set-ItemProperty -Path $file.FullName -Name IsReadOnly -Value $false
		}
	}
}