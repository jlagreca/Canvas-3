function Get-CanvasUser
{
    [CmdletBinding(DefaultParameterSetName = "Filter")]
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = "Identity")]
        [Parameter(Mandatory = $true, ParameterSetName = "Filter")]
        [Parameter(Mandatory = $true, ParameterSetName = "All")]
        [Canvas.Connection]
        $Connection,
        
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
            Method      = "Get"
            Url         = $Connection.CanvasUrl
            ApiBase     = "api/v1/accounts/$($Connection.Accountid)"
            ApiEndpoint = "users"
            Credential  = $Connection.Credential
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
