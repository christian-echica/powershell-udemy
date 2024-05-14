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