function New-Session
{
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .PARAMETER
        
        .EXAMPLE
        
        .NOTES
        ToDo
        - Currently creating global variable for each created session; should change this to push them into
        a stack that can be used as an enum
        .LINK
        
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        $Name,

        [Parameter(Mandatory = $true)]
        $Url
    )
    
    dynamicparam
    {
        $Dictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
        $Options = Get-ChildItem -Path $TokensPath -File -Filter *.clixml |
        Where-Object { $_ -like "*$env:ComputerName*" } |
        Select-Object -ExpandProperty Name
        $ParamAttr = New-Object -TypeName System.Management.Automation.ParameterAttribute
        $ParamOptions = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList $Options
        $AttributeCollection = New-Object -TypeName 'Collections.ObjectModel.Collection[System.Attribute]'
        $AttributeCollection.Add($ParamAttr)
        $AttributeCollection.Add($ParamOptions)
        $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @('ApiToken', [string],$AttributeCollection)
        $Dictionary.Add('ApiToken', $Parameter)
        $Dictionary
    }
    
    process
    {
        try
        {
            # url and name validation
            $Url = $(if ($Url -like 'https://*') { $Url } else { "https://$($Url)" }) -replace '/$'            
            $Token = Import-Clixml -Path "$TokensPath\$($PSBoundParameters.ApiToken)" -ErrorAction Stop

            # test connectivity to URL and authentication using token
            $Uri = "$Url/api/v1/accounts"
            $AuthHeader = @{ Authorization = "Bearer $($Token.GetNetworkCredential().Password)" }
            $null = Invoke-RestMethod -Method Get -Uri $Uri -Headers $AuthHeader -ErrorAction Stop -SessionVariable $Name
            $Session = Get-Variable $Name -ValueOnly
			$Session | Add-Member -MemberType NoteProperty -Name Name -Value $Name
			$Session | Add-Member -MemberType NoteProperty -Name Url -Value $Url
			$Session.PSObject.TypeNames.Insert(0, $TypeNames['Session'])
        }
        catch [System.IO.FileNotFoundException]{ throw "Api token file not found!" }
        catch [System.Net.WebException]
		{
			throw "There was a problem connecting to the Canvas API. Make sure you have a valid Url and token."
		}
    }

    end
	{
		$CanvasSessions += $Session
		$Session
	}
}