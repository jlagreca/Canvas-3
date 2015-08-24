function Get-Course
{
    [CmdletBinding()]
    param
    (        
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )
    
    if (!$CanvasSession) {throw "You didn't specify a Canvas Session!"}

    $Url = $CanvasSession.Url
    $ApiEndpoint = 'api/v1/accounts/self/courses'
    $Uri = "$Url/$ApiEndpoint"
    $Request = Invoke-RestMethod -Uri $uri -Method Get -WebSession $CanvasSession -Body $Body

	# Convert this to use ConvertTo-Object - refactor ConvertTo-User to take an object name parameter
    foreach ($Result in $Request)
    {
        $Properties = @{}
        foreach ($Property in $Result.PsObject.Properties)
        {
            $Properties."$($Property.Name)" = $Property.Value
        }
        $Properties.PSTypeName = 'Canvas.Course'
        $Properties.CanvasSession = $CanvasSession
        New-Object -TypeName PSCustomObject -Property $Properties
    }
}