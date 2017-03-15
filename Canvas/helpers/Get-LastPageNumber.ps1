function Get-LastPageNumber
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $Link
    )
    
    $LastPage = ($Link -split "," | Where-Object {$_ -like '* rel="last"'}) -split ";| |<|>" |
    Where-Object {$_} | Select-Object -First 1
    
    $null = $LastPage -match "page=(?'PageNumber'[0-9]+)"
    $Matches.PageNumber
}
