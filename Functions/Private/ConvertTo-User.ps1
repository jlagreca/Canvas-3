function ConvertTo-User
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Object[]]
        $InputObject
    )
    
    PROCESS
    {
        foreach ($Item in $InputObject)
        {
            $Properties = @{}
            foreach ($Property in $Item.PsObject.Properties)
        {
            $Properties."$($Property.Name)" = $Property.Value
        }
        $Properties.PSTypeName = $TypeNames['User']
        New-Object -TypeName PSCustomObject -Property $Properties
        }
    }
}