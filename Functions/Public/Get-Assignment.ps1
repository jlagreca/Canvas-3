function Get-Assignment
{
    [CmdletBinding(DefaultParameterSetName='Named')]
    PARAM
    (
        [Parameter(ValueFromPipeline=$true,ParameterSetName='Piped')]
        [PSTypeName('Canvas.Course')]
        $CanvasCourse,
        
        [Parameter(ParameterSetName='Named')]
        [int]
        $CourseId,
        
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [PSTypeName('Canvas.Session')]
        $CanvasSession
    )
    
    BEGIN
    {
        if (!$CanvasSession) { throw "You forgot to specify a Canvas session!" }
        $VerbosePreference = 'SilentlyContinue'
    }

    PROCESS
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            'Piped' {$CourseId = $CanvasCourse.Id}
        }
        
        $Url = $CanvasSession.Url
        $ApiEndpoint = "api/v1/courses/$CourseId/assignments"
        $Uri = "$Url/$ApiEndpoint"
        $Request = Invoke-RestMethod -Uri $uri -Method Get -WebSession $CanvasSession -Body $Body

        foreach ($Result in $Request)
        {
            $Properties = @{}
            foreach ($Property in $Result.PsObject.Properties)
            {
                $Properties."$($Property.Name)" = $Property.Value
            }
            $Properties.PSTypeName = 'Canvas.Assignment'
            $Properties.CanvasSession = $CanvasSession
            New-Object -TypeName PSCustomObject -Property $Properties
        }
    }
}