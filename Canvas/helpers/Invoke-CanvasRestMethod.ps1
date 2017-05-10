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
        Uri = $Uri
        Method = $Method
        ContentType = "application/json"
        Headers = @{Authorization = "Bearer $($Credential.GetNetworkCredential().Password)"}
        Body = $Body
    }
    
    Do
    {
        $WebRequest = Invoke-WebRequest @Splat -ErrorAction Stop
        ($WebRequest.Content | ConvertFrom-Json)
        $NextPage = Get-NextPageNumber -Link $WebRequest.Headers.Link
        $Splat["Uri"] = "$Uri`?page=$NextPage"
    }
    While ($NextPage)
}
