function Get-CanvasAccount
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [Canvas.Connection]
        $Connection,

        [int]
        $Identity,

        [switch]
        $Recurse
    )
    
    BEGIN
    {
        $Splat = @{
            Method      = "Get"
            Url         = $Connection.CanvasUrl
            ApiBase     = "api/v1"
            ApiEndpoint = "accounts"
            Credential  = $Connection.Credential
            TypeName    = "Canvas.Account"
        }

        if ($Identity)
        {
            $Splat["ApiEndpoint"] += "/$Identity"
        }
    }
    
    PROCESS
    {
        Invoke-CanvasRestMethod @Splat | ForEach-Object { [Canvas.Account]$_ }
    }
}
