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
	} catch {
		Write-Warning "Remove-Item failed somehow on file $($file.FullName)."
	}
}