function New-User
{
	<#
		.SYNOPSIS
        
		.DESCRIPTION
        
		.PARAMETER
        
		.EXAMPLE
        
		.NOTES
		to-do:
		- Rewrite according to standards in Get-CanvasUser below
		- define what parameters are needed to create a new user from scratch
		- Can users be created from an instance user?
		- Are users per tenant or per account?
		- assign a role to a user
		.
		https://canvas.instructure.com/doc/api/users.html
	#>

    [CmdletBinding()]
    param
    (
        [String]
        $Name,
        
        [String]
        $DisplayName,
        
        [String]
        $SortableName,
        
        [String]
        $TimeZone = "Eastern Time (US & Canada)",
        
        [String]
        $Locale = 'en',
        
        [System.DateTime]
        $BirthDate,
        
        # Should I use a parameter set here for sub-members of the pseudonym?
        [Parameter(Mandatory = $true)]
        [String]
        $Login,
        
        $AccountId = 1,

        [Parameter(Mandatory = $true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )
    
    $VerbosePreference = 'SilentlyContinue'

    $Body = @{
        'user[name]'                   = $Name
        'user[time_zone]'              = $TimeZone
        'user[locale]'                 = $Locale
        'pseudonym[unique_id]'         = $Login
        'pseudonym[send_confirmation]' = $false
    }
    
    switch ($Link)
    {
        {$Link.ContainsKey('DisplayName')}  { $Body.'user[short_name]' = $DisplayName }
        {$Link.ContainsKey('SortableName')} { $Body.'user[sortable_name]' = $SortableName }
        {$Link.ContainsKey('BirthDate')}    { $Body.'user[birthdate]' = Get-Date $Birthdate -format s }
    }

    $Url = $CanvasSession.Url
    $Uri = "$Url/api/v1/accounts/$AccountId/users"
    Invoke-RestMethod -WebSession $CanvasSession -Method POST -Uri $Uri -Body $Body
}