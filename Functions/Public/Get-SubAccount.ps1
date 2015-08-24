function Get-SubAccount
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
        [Parameter(ValueFromPipeline = $true)]
        [Parameter(ParameterSetName='Piped')]
        [PSTypeName('Canvas.Account')]
        $Account,
        
        [Parameter(ParameterSetName='Named')]
        [int]
        $AccountId,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession,

        [switch]
        $Recurse
    )
    
    BEGIN
    {
        #if (!$PSBoundParameters.ContainsKey('CanvasSession')) { throw "You forgot to specify a Canvas session!" }
        $VerbosePreference = 'SilentlyContinue'
    }

    PROCESS
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'Piped' {$AccountId = $Account.id}
        }
        
        if ($Recurse) {$Body = @{recursive = $true}}
        $Url = $CanvasSession.Url
        $Token = $CanvasSession.ApiToken.GetNetworkCredential().Password
        $Uri = "$Url/api/v1/accounts/$AccountId/sub_accounts"
        $AuthHeader = @{Authorization = "Bearer $Token"}
        $Request = Invoke-RestMethod -Uri $uri -Method Get -Headers $AuthHeader -Body $Body

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