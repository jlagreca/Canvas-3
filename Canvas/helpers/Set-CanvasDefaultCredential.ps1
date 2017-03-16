function Set-CanvasDefaultConnection
{
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium")]
    param
    (
        [Canvas.Connection]
        $Connection
    )

    $ModuleName = $PSCmdlet.MyInvocation.MyCommand.Module.Name
    $Module = Get-Module -Name $ModuleName
    $global:Commands = $Module.ExportedCommands.GetEnumerator()  |
        Select-Object -ExpandProperty value |
        Where-Object {(Get-Command $_).Parameters.Keys -contains "Connection"} |
        Select-Object -ExpandProperty name

    if ($PSCmdlet.ShouldProcess($Commands, "Set default connection"))
    {
        foreach ($Command in $Commands)
        {
            $Global:PSDefaultParameterValues["$Command`:Connection"] = $Connection
        }
    } 
}
