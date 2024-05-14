$color = 'red'
Select-Object -InputObject $color -Property *

$color.Length

Get-Member -InputObject $color

# String
$language = 'Java'
$sentence = "Powershell rocks but $language is a close second"
$sentence

#Boolean
$isEnabled = $true
$isEnabled

#Numbers
$num = 1
$output = $num * 2
$output
$output.GetType().Name #this returns Int32

#Casting converting from one type to another
$num = [float]$num
$num.GetType().Name #this returns Single


#ScriptBlock
Test-Path -Path C:\file.txt #returns False
$myscriptBlock = { Test-Path -Path C:\file.txt } #scripBlock type example
$myscriptBlock # should return False ofcors


#Hashtables and Array
$colorPicker = @('blue','white','yellow','black')
$colorPicker
#if want to choose individual from the array
$colorPicker[2] + " is the choosen one"  #should return yellow
#if select multiple
$colorPicker[0..2] + " is multiple select " # returns blue white yellow
$colorPicker[0] = 'pink' #changes the 0 placer means from blue to pink
$colorPicker + 'orange' # adds another item in the array
$colorPicker += @('green','purple') #add multiple in array

#Best practice is always to convert Array to List 
$colorPicker = [System.Collections.Generic.List[string]]@('blue','white','yellow','black','green','purple')
$colorPicker
$colorPicker.Add('gray'); $colorPicker
$colorPicker.Remove('gray'); $colorPicker

#Hashtables
$users = @{
    abertram = 'Adam Bertram';
    raquelcer = 'Raquel Cerillo';
    zheng21 = 'Justin Zheng'
   }
$users
$users['abertram']
$users.abertram
$users.Keys
$users.Values
Select-Object -InputObject $users -Property * #Nice looking result like this
$users['phrigo'] = 'Phil Rigo'
$users
$users.ContainsKey('johnnyq') #search an item and returns boolean value
$users.ContainsKey('phrigo')
$users
$users.Remove('raquelcer') #removes an item
$users


## Running Get-Service
Get-Service

## Starting a Windows Service

$serviceName = 'wuauserv'
Get-Service -Name $serviceName

Stop-Service -Name $serviceName

## Using the Pipeline

Get-Service -Name 'wuauserv' | Stop-Service
'wuauserv' | Get-Service | Stop-Service

## Stop all services
Get-Service | Stop-Service

## Read all services
Get-Content -Path C:\Services.txt | Get-Service

## How to see if a command supports pipeline input
Get-Help -Name Stop-Service -Full

## Looking at Parameter Binding

'explorer' | Get-Process
'wuauserv' | Get-Service


#### Creating a Script the Hard way ####
"Test-Connection -ComputerName 1.1.1.1 -Quiet -Count 1`nGet-Service -Name 'wuauserv'" | Set-Content -Path 'C:\somescript.ps1'

Get-Content -Path C:\somescript.ps1

C:\somescript.ps1

Get-ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy 



