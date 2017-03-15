function Get-CanvasUser
{
    [CmdletBinding(DefaultParameterSetName = "Filter")]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = "All")]
        [Parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Parameter(Mandatory = $true, ParameterSetName = "Identity")]
        [string]
        $CanvasUrl,

        [Parameter(Mandatory = $true, ParameterSetName = "All")]
        [Parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Parameter(Mandatory = $true, ParameterSetName = "Identity")]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true, ParameterSetName = "All")]
        [Parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Parameter(Mandatory = $true, ParameterSetName = "Identity")]
        [string]
        $AccountId,
        
        [Parameter(Mandatory = $true, ParameterSetName = "Identity")]
        [int]
        $Identity,
        
		[Parameter(Mandatory = $true, ParameterSetName = "Filter")]
		[ValidateScript({ $_.length -ge 3 })]
        [String]
        $Filter,

        [Parameter(Mandatory = $true, ParameterSetName = "All")]
        [switch]
        $All
    )
    
    BEGIN
    {
        $Splat = @{
            Url         = Validate-Url -Url $CanvasUrl
            ApiBase     = "api/v1/accounts/$AccountId"
            ApiEndpoint = "users"
            Credential  = $Credential
            Method      = "Get"
        }
    }
    
    PROCESS
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            "Identity"
            {
                $Splat["Body"] =  @{search_term = $Identity}
            }

            "Filter"
            {
                $Splat["Body"] = @{search_term = $Filter}
            }
        }

        Invoke-CanvasRestMethod @Splat | ForEach-Object { $_ -as [Canvas.User] }
    }
}
