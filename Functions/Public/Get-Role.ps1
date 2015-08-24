function Get-Role
{
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .PARAMETER
        
        .EXAMPLE
        
        .NOTES
        
        .LINK
        
    #>
    [CmdletBinding(DefaultParameterSetName='Named')]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        $AccountId
    )

    BEGIN
    {
        if (!$CanvasSession) { throw "You forgot to specify a Canvas session!" }
        $VerbosePreference = 'SilentlyContinue'
    }

    PROCESS
    {
        $Url = $CanvasSession.Url
        $ApiEndpoint = "api/v1/accounts/$AccountId/roles"
        $Uri = "$Url/$ApiEndpoint"
        $Request = Invoke-RestMethod -Uri $uri -Method Get -WebSession $CanvasSession -Body $Body

        foreach ($Result in $Request)
        {
            $Properties = @{}
            foreach ($Property in $Result.PsObject.Properties)
            {
                $Properties."$($Property.Name)" = $Property.Value
            }
            $Properties.PSTypeName = 'Canvas.Role'
            $Properties.CanvasSession = $CanvasSession
            New-Object -TypeName PSCustomObject -Property $Properties
        }
    }
}