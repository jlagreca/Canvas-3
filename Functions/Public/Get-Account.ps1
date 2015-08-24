function Get-Account
{
    <#
        .SYNOPSIS
    
        .DESCRIPTION
    
        .PARAMETER
    
        .EXAMPLE
    
        .NOTES
        To-Do:
        - Add filter parameter to filter to a specific account name
        - How to deal with sub-accounts and recursion?
        .LINK
    
    #>
    [CmdletBinding()]
    param
    (
        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )
    
    BEGIN
    {
        if (!$CanvasSession) { throw "You forgot to specify a Canvas session!" }
        $VerbosePreference = 'SilentlyContinue'
    }

    PROCESS
    {
        $ApiEndpoint = 'api/v1/accounts'
        $Uri = "$($CanvasSession.Url)/$ApiEndpoint"
        $Request = Invoke-RestMethod -WebSession $CanvasSession -Method Get -Uri $Uri

        foreach ($Result in $Request)
        {
            $Properties = @{}
            foreach ($Property in $Result.PsObject.Properties)
            {
                $Properties."$($Property.Name)" = $Property.Value
            }
            $Properties.PSTypeName = 'Canvas.Account'
            $Properties.CanvasSession = $CanvasSession
            New-Object -TypeName PSCustomObject -Property $Properties
        }
    }
    
}