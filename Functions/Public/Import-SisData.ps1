function Import-SisData
{
    <#
        .SYNOPSIS
        Import SIS data

        .DESCRIPTION
        Import SIS data into Canvas. Must be on a root account with SIS imports
        enabled.
		
		.PARAMETER	AccountId
		The numerical Id of the account to run the import on. This should always be your root Canvas account
		and defaults to '1'.	

		.PARAMETER Path
		The full path to the csv file to be imported.

		.PARAMETER CanvasSession
		A Canvas web session that can be used to connect to the web service.

        .EXAMPLE

        .NOTES

        .LINK
		https://canvas.instructure.com/doc/api/sis_imports.html
		https://canvas.instructure.com/doc/api/file.sis_csv.html

    #>
    
    [CmdletBinding()]
    param
    (
        [string]
		${AccountId} = '1',
		
		[string]
		$Path,

        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )

    $VerbosePreference = 'SilentlyContinue'
    if (!$CanvasSession) { throw "You forgot to specify a Canvas session!" }
    $Url = $CanvasSession.Url
    $ApiEndpoint = "api/v1/accounts/$AccountId/sis_imports"
    $Uri = "$Url/$ApiEndpoint"

	$Splat = @{
		Uri         = $Uri
		Method      = 'POST'
		WebSession  = $CanvasSession
		ContentType = 'application/zip'
		InFile      = $Path
	}

    Invoke-RestMethod @Splat
}