function Validate-Url
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Url
    )
    
    $(if ($Url -like 'https://*') { $Url } else { "https://$($Url)" }) -replace '/$'
}
