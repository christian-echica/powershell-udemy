#region foreach
$servers = @('localhost','SRV2','SRV3','SRV4')

## Iterating over each element in the array and running some code "for each" item
foreach ($server in $servers) {
    Write-Host "I'm processing server $server right now..."
} 

$servers.Count

## Useful for smaller arrays to use the pipeline
$servers | ForEach-Object {
    Write-Host "I'm processing server $_ right now..."
}

## The foreach() Method (A method on an array; fastest)

$servers.foreach({Write-Host "I'm processing server $_ right now..."})

#endregion

#region for

## The for Loop (Allows you to reference elment indexes dynamically)
for ($i = 0; $i -lt 10; $i++) {
    Write-Host "I'm on iteration number $i now."
}

## Change the value of array items
for ($i = 0; $i -lt $servers.Length; $i++) {
    $servers[$i] = "new $($servers[$i])"
}
$servers

## Reference elements before or after based on the current item
for ($i = 1; $i -lt $servers.Length; $i++) {
    Write-Host $servers[$i] "comes after" $servers[$i-1]
}

## But what if the problem is a little more complex? A number in the file name
$servers = @('localhost','SRV2','SRV3','SRV4')
Get-Content -Path "\\$($servers[0])\c$\App_configuration1.txt"
Get-Content -Path "\\$($servers[1])\c$\App_configuration2.txt"
Get-Content -Path "\\$($servers[2])\c$\App_configuration3.txt"
Get-Content -Path "\\$($servers[3])\c$\App_configuration4.txt"

for ($i = 0; $i -lt $servers.Count; $i++) {
    Write-Host "Processing servers array index number $i which is server $($servers[$i])..."
		Write-Host "The next servers array index after this one is $($i + 1)."
		Write-Host "Looking for file name App_configuration$($i+1).txt..."
    Get-Content -Path "\\$($servers[$i])\c$\App_configuration$($i+1).txt"
}

#endregion

#region while/do while/do until

## The while Loop (Do something while a specific state for something else)

$counter = 0
while ($counter -lt 10) {
    $counter
    $counter++
}

## Ping SOMESERVER every second only while Test-Connection returns true
while (Test-Connection -ComputerName 'SOMESERVER' -Quiet -Count 1) {
    Start-Sleep -Seconds 1
}
Write-Host 'SOMESERVER is now offline.'

## The do/while loop (Do something THEN CONTINUE doing something until a condition is met)
do {
    $choice = Read-Host -Prompt 'What is the best programming language?'
} while ($choice -ne 'PowerShell')

## The do/until loop (Do something THEN STOP when a condition is met)
do {
    $choice = Read-Host -Prompt 'What is the best programming language?'
} until ($choice -eq 'PowerShell') {
    Write-Host -Object 'Correct!'
}

#endregion


### FOR LOOPS ##
#region for

## The for Loop (Allows you to reference elment indexes dynamically)
for ($i = 0; $i -lt 10; $i++) {
    Write-Host "I'm on iteration number $i now."
}

## Change the value of array items
for ($i = 0; $i -lt $servers.Length; $i++) {
    $servers[$i] = "new $($servers[$i])"
}
$servers

## Reference elements before or after based on the current item
for ($i = 1; $i -lt $servers.Length; $i++) {
    Write-Host $servers[$i] "comes after" $servers[$i-1]
}

## But what if the problem is a little more complex? A number in the file name
$servers = @('localhost','SRV2','SRV3','SRV4')
Get-Content -Path "\\$($servers[0])\c$\App_configuration1.txt"
Get-Content -Path "\\$($servers[1])\c$\App_configuration2.txt"
Get-Content -Path "\\$($servers[2])\c$\App_configuration3.txt"
Get-Content -Path "\\$($servers[3])\c$\App_configuration4.txt"

for ($i = 0; $i -lt $servers.Count; $i++) {
    Write-Host "Processing servers array index number $i which is server $($servers[$i])..."
		Write-Host "The next servers array index after this one is $($i + 1)."
		Write-Host "Looking for file name App_configuration$($i+1).txt..."
    if (Test-Path -Path "\\$($servers[$i])\c$\App_configuration$($i+1).txt") {
        Get-Content -Path "\\$($servers[$i])\c$\App_configuration$($i+1).txt"
    } else {
        Write-host "\\$($servers[$i])\c$\App_configuration$($i+1).txt does not exist."
    }
    
}

#endregion