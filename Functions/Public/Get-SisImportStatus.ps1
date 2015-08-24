function Get-SisImportStatus
{
    <#
        .SYNOPSIS
        Get SIS import status

        .DESCRIPTION
        Get the status of an already created SIS import.

        Examples:
        curl 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports/<sis_import_id>' \
        -H "Authorization: Bearer <token>"

        .PARAMETER account_id
        ID
        .PARAMETER id
        ID

        .EXAMPLE

        .NOTES

        .LINK

    #>
    
    [CmdletBinding()]
    param
    (
        [string]${account_id},
        [string]${id}
    )

    begin
    {

    }

    process
    {
        $AuthHeader = @{Authorization = "Bearer $($CanvasApiToken.GetNetworkCredential().Password)"}
        $Uri = "https://$CanvasDomainName/v1/accounts/$account_id/sis_imports/$id"
        Invoke-RestMethod -Uri $Uri -Method GET -Headers $AuthHeader
    }

    end
    {

    }
}