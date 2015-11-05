Function Save-ApiToken
{
    <#
        .SYNOPSIS
        
        .DESCRIPTION
        
        .PARAMETER
        
        .EXAMPLE
        
        .NOTES
        put email address in username box, put apitoken in password box
        .LINK
        
    #>
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [System.Management.Automation.CredentialAttribute()]
        $Credential,
        
        [String]
        $Path = $TokensPath
    )
    
    $FileName = "$($Credential.UserName)_$Env:ComputerName.clixml"
    $Credential | Export-Clixml -Path "$Path\$FileName" -NoClobber
    "$Path\$FileName"
}