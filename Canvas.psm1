$ModuleRoot = $PSScriptRoot
$TokensPath = "$ModuleRoot\Tokens"
$FunctionsPath = "$ModuleRoot\Functions"
$NameSpace = 'Canvas'
$TypeNames = @{
	User       = "$NameSpace.User"
	Account    = "$NameSpace.Account"
	Session    = "$NameSpace.Session"
	SisImport  = "$NameSpace.SisImport"
	Course     = "$NameSpace.Course"
	Assignment = "$NameSpace.Assignment"
	Submission = "$NameSpace.Submission"
	Role       = "$NameSpace.Role"
}

$Scripts = Get-ChildItem -Path $FunctionsPath -Filter '*.ps1' -file -Recurse

foreach ($Script in $Scripts)
{
	. $Script.FullName
}

