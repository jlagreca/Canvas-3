function New-CanvasConnection
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
            [System.Uri]::IsWellFormedUriString($_, "Absolute")
        })]
        [System.Uri]
        $CanvasUrl,

        [Parameter(Mandatory = $true)]
        [int]
        $AccountID,

        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential,

        [switch]
        $SetAsDefault
    )
    
    try
    {
        # test connectivity to URL and authentication using token
        $Uri = "$CanvasUrl/api/v1/accounts"
        $AuthHeader = @{ Authorization = "Bearer $($Credential.GetNetworkCredential().Password)" }
        $null = Invoke-RestMethod -Method Get -Uri $Uri -Headers $AuthHeader -ErrorAction Stop
        $Connection = [Canvas.Connection]@{
            CanvasUrl  = $CanvasUrl
            AccountID  = $AccountID
            Credential = $Credential
        }

        if ($SetAsDefault)
        {
            Set-CanvasDefaultConnection -Connection $Connection
        }

        $Connection
    }
    catch [System.Net.WebException]
    {
        $ErrorMessage = "There was a problem connecting to the Canvas API. Make sure you have a valid Url and token."
        Write-Error -Message $ErrorMessage -ErrorAction Stop
    }
}
