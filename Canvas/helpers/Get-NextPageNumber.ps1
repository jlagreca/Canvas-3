function Get-NextPageNumber
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $Link
    )
    
    $NextPage = ($Link -split "," | Where-Object {$_ -like '* rel="next"'}) -split ";| |<|>" |
    Where-Object {$_} | Select-Object -First 1
    
    $null = $NextPage -match "page=(?'PageNumber'[0-9]+)"
    $Matches.PageNumber
}
