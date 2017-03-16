function Get-ValidUrl
{
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            [System.Uri]::IsWellFormedUriString($_, "Absolute")
        })]
        [string]
        $Url
    )
    
    $OutputUrl = switch -Regex  ($Url)
    {
        "^(?!http://)|(?!https://)" { "https://" + $Url; break }
        "^http://.+"  { $Url -replace "http://", "https://" }
        
    }

    $OutputUrl -replace "/$"
}
