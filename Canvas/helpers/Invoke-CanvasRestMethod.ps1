function Invoke-CanvasRestMethod
{
    [CmdletBinding()]
    param
    (
        [string]
        $Method,

        [Parameter(Mandatory)]
        [string]
        $Url,

        [Parameter(Mandatory)]
        [string]
        $ApiBase,
        
        [Parameter(Mandatory)]
        [string]
        $ApiEndpoint,
        
        [Parameter(Mandatory)]
        [pscredential]
        $Credential,

        [hashtable]
        $Body = @{}
    )
    
    $Body["per_page"] = 100
    $Uri = "$Url/$ApiBase/$ApiEndpoint"
    $Splat = @{
        Method      = $Method
        ContentType = "application/json"
        Headers     = @{Authorization = "Bearer $($Credential.GetNetworkCredential().Password)"}
        Body        = $Body
    }
    
    $WebRequest = Invoke-WebRequest @Splat -Uri $Uri -ErrorAction Stop
    $NumPages = Get-LastPageNumber -Link $WebRequest.Headers.Link

    foreach ($Page in 1..$NumPages)
    {
        Invoke-RestMethod -Uri "$Uri`?page=$Page" @Splat | Foreach-Object { $_ }
    }
}
