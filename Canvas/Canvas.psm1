$ClassesPath = Join-Path $PSScriptRoot "classes"
$Classes = Get-ChildItem -Path $ClassesPath -Filter "*.cs" -File -Recurse
foreach ($Class in $Classes)
{
	Add-Type -Path $Class.FullName
}

$FunctionsPath = Join-Path $PSScriptRoot "functions"
$HelpersPath = Join-Path $PSScriptRoot "helpers"
$Scripts = Get-ChildItem -Path $FunctionsPath,$HelpersPath -Filter "*.ps1" -file -Recurse

foreach ($Script in $Scripts)
{
	. $Script.FullName
}
