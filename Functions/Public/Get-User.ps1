function Get-User
{
    [CmdletBinding(DefaultParameterSetName = 'Filter')]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Filter')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Identity')]
        [PSTypeName('Canvas.Session')]
        $CanvasSession,

        [Parameter(ParameterSetName = 'Filter')]
        [Parameter(ParameterSetName = 'Identity')]
        [string]
        $AccountId = '1',
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Identity')]
        [int]
        $Identity,
        
		[Parameter(Mandatory = $true, ParameterSetName = 'Filter')]
		[ValidateScript({ $_.length -ge 3 -or $_ -eq '*' })]
        [String]
        $Filter
    )
    
    BEGIN
    {
        $VerbosePreference = 'SilentlyContinue'
        if (!$CanvasSession) { throw "You forgot to specify a Canvas session!" }
        $Url = $CanvasSession.Url
    }
    
    PROCESS
    {
        # Set up the base url and parameters
        $Uri = "$Url/api/v1/accounts/$AccountId/users"
        $Splat = @{
            WebSession = $CanvasSession
            Method  = 'Get'
            Uri     = $Uri
            Body    = @{per_page = 100}
        }
        
        if ($PSCmdlet.ParameterSetName -eq 'Identity')
        {
            # Here we're looking for a particular user by id
			# search_term will check for an ID if the argument is numerical and under 3 characters
			# otherwise, multiple users will be returned, so we have to check what's returned first and filter it.
            $Splat['Body'].Add('search_term', $Identity)
            $Rest = Invoke-RestMethod @Splat
			if ($Rest.count -gt 1)
			{
				$Rest = $Rest | Where-Object Id -EQ $Identity
			}
			$Rest | ConvertTo-User
        }
        else
        {
            # we're using a filter here to find all users or based on a search term
            if ($Filter -ne '*')
            {
                $Splat['Body'].Add('search_term', $Filter)
            }
            $Request = Invoke-WebRequest @Splat
            
            # cycle through each page and return the results
            $NumPages = Get-LastPageNumber -Request $Request
            Invoke-RestMethodPaged @Splat -Pages $NumPages | ConvertTo-User
        }
    }
}