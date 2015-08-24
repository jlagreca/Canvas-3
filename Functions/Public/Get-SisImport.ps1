function Get-SisImport
{
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .PARAMETER
        
        .EXAMPLE
        
        .NOTES
        
        .LINK
        
    #>
    [CmdletBinding()]
    param
    (
        [PSTypeName('Canvas.Session')]
        $CanvasSession,
        
        $AccountId = 1
    )
    
    $VerbosePreference = 'SilentlyContinue'
    
    $Url = $CanvasSession.Url
    $ApiEndpoint = "api/v1/accounts/$AccountId/sis_imports"
    $Token = $CanvasSession.ApiToken.GetNetworkCredential().Password
    $Uri = "$Url/$ApiEndpoint"
    $AuthHeader = @{Authorization = "Bearer $Token"}
    $Request = Invoke-RestMethod -Uri $uri -Method Get -Headers $AuthHeader

    foreach ($Result in $Request.sis_imports)
    {
        $Properties = @{}
        foreach ($Property in $Result.PsObject.Properties)
        {
            $Properties."$($Property.Name)" = $Property.Value
        }
        $Properties.PSTypeName = 'Canvas.SisImport'
        $Properties.CanvasSession = $CanvasSession
        New-Object -TypeName PSCustomObject -Property $Properties
    }
}