function Set-User
{
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $id,
        
        [Parameter(Mandatory = $false)]
        [string]
        $sis_user_id,
        
        [Parameter(Mandatory = $false)]
        [string]
        $short_name,
        
        [Parameter(Mandatory = $false)]
        [string]
        $sortable_name,
        
        [Parameter(Mandatory = $false)]
        [string]
        $name,
        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )    
    
    BEGIN
    {
        $Url = $CanvasSession.Url
    }
    
    PROCESS
    {
        $VerbosePreference = 'SilentlyContinue'
        
        if ($PSCmdlet.ShouldProcess($Id))
        {
            ### Set user properties
            $Uri = "$Url/api/v1/users/$Id"
            $UserBody = @{}
            switch ($PSBoundParameters)
            {
                { $_.ContainsKey('name') }          { $UserBody.Add('user[name]', $name) }
                { $_.ContainsKey('short_name') }    { $UserBody.Add('user[short_name]', $short_name) }
                { $_.ContainsKey('sortable_name') } { $UserBody.Add('user[sortable_name]', $sortable_name) }
            }
            
            Invoke-RestMethod -WebSession $CanvasSession -Method Put -Uri $Uri -Body $UserBody

            ### Set login properties
            if ($sis_user_id)
            {
                $LoginBody = @{
                    'login[sis_user_id]' = $sis_user_id
                }

                $Uri = "$Url/api/v1/accounts/1/logins/$Id"
                Invoke-RestMethod -WebSession $CanvasSession -Method Put -Uri $Uri -Body $LoginBody
            }
        }
    }
}