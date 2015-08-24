function Import-SisData
{
    <#
        .SYNOPSIS
        Import SIS data

        .DESCRIPTION
        Import SIS data into Canvas. Must be on a root account with SIS imports
        enabled.

        For more information on the format that's expected here, please see the
        "SIS CSV" section in the API docs.

        .PARAMETER account_id
        ID
        .PARAMETER import_type
        Choose the data format for reading SIS data. With a standard Canvas install, this option can only be 'instructure_csv', and if unprovided, will be assumed to be so. Can be part of the query string.
        .PARAMETER attachment
        There are two ways to post SIS import data - either via a multipart/form-data form-field-style attachment, or via a non-multipart raw post request. 'attachment' is required for multipart/form-data style posts. Assumed to be SIS data from a file upload form field named 'attachment'. Examples: curl -F attachment=@<filename> -H "Authorization: Bearer <token>" \ 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports.json?import_type=instructure_csv' If you decide to do a raw post, you can skip the 'attachment' argument, but you will then be required to provide a suitable Content-Type header. You are encouraged to also provide the 'extension' argument. Examples: curl -H 'Content-Type: application/octet-stream' --data-binary @<filename>.zip \ -H "Authorization: Bearer <token>" \ 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports.json?import_type=instructure_csv&extension=zip' curl -H 'Content-Type: application/zip' --data-binary @<filename>.zip \ -H "Authorization: Bearer <token>" \ 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports.json?import_type=instructure_csv' curl -H 'Content-Type: text/csv' --data-binary @<filename>.csv \ -H "Authorization: Bearer <token>" \ 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports.json?import_type=instructure_csv' curl -H 'Content-Type: text/csv' --data-binary @<filename>.csv \ -H "Authorization: Bearer <token>" \ 'https://<canvas>/api/v1/accounts/<account_id>/sis_imports.json?import_type=instructure_csv&batch_mode=1&batch_mode_term_id=15'
        .PARAMETER extension
        Recommended for raw post request style imports. This field will be used to distinguish between zip, xml, csv, and other file format extensions that would usually be provided with the filename in the multipart post request scenario. If not provided, this value will be inferred from the Content-Type, falling back to zip-file format if all else fails.
        .PARAMETER batch_mode
        If set, this SIS import will be run in batch mode, deleting any data previously imported via SIS that is not present in this latest import. See the SIS CSV Format page for details.
        .PARAMETER batch_mode_term_id
        Limit deletions to only this term. Required if batch mode is enabled.
        .PARAMETER override_sis_stickiness
        Many fields on records in Canvas can be marked "sticky," which means that when something changes in the UI apart from the SIS, that field gets "stuck." In this way, by default, SIS imports do not override UI changes. If this field is present, however, it will tell the SIS import to ignore "stickiness" and override all fields.
        .PARAMETER add_sis_stickiness
        This option, if present, will process all changes as if they were UI changes. This means that "stickiness" will be added to changed fields. This option is only processed if 'override_sis_stickiness' is also provided.
        .PARAMETER clear_sis_stickiness
        This option, if present, will clear "stickiness" from all fields touched by this import. Requires that 'override_sis_stickiness' is also provided. If 'add_sis_stickiness' is also provided, 'clear_sis_stickiness' will overrule the behavior of 'add_sis_stickiness'

        .EXAMPLE

        .NOTES

        .LINK

    #>
    
    [CmdletBinding()]
    param
    (
        [string]${AccountId},
        [string]${import_type},
        [string]${attachment},
        [string]${extension},
        [boolean]${batch_mode},
        [string]${batch_mode_term_id},
        [boolean]${override_sis_stickiness},
        [boolean]${add_sis_stickiness},
        [boolean]${clear_sis_stickiness}
    )

    $VerbosePreference = 'SilentlyContinue'
    
    $Url = $CanvasSession.Url
    $ApiEndpoint = "api/v1/accounts/$AccountId/sis_imports"
    $Uri = "$Url/$ApiEndpoint"
    # the below method worked with a zip 'file'
    Invoke-RestMethod -Uri $Uri -Method POST -WebSession $CanvasSession -Body $body -Verbose -ContentType application/zip -InFile .\users.zip
    #Invoke-RestMethod -Uri $Uri -Method POST -Headers $AuthHeader
}