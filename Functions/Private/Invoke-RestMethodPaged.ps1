function Invoke-RestMethodPaged
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [string]
        $Uri,
        
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession,
        
        [Parameter(Mandatory=$false)]
        [int]
        $Pages,
        
        $Headers,
        $Method,
        $Body
    )
    
    $Splat = $PSBoundParameters
    $null = $Splat.Remove('Uri')
    $null = $Splat.Remove('Pages')
    
    foreach ($Page in 1..$Pages)
    {
        Invoke-RestMethod -Uri "$Uri`?page=$Page" @Splat
    }
}