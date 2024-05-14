# WITHOUT ERROR HANDLING 
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
	Remove-Item -Path $file.FullName
	Write-Verbose -Message "Successfully removed [$($file.FullName)]."
}