function Get-Submission
{
    [CmdletBinding(DefaultParameterSetName='Named')]
    param
    (
        [Parameter(ParameterSetName='Named')]
        $CourseId,
        
        [Parameter(ParameterSetName='Named')]
        $AssignmentId,
        
        [Parameter(ParameterSetName='Piped',ValueFromPipeline=$true)]
        [PSTypeName('Canvas.Assignment')]
        $CanvasAssignment, 
        
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
            'Piped' {$CourseId = $CanvasAssignment.course_id; $AssignmentId = $CanvasAssignment.id}
        }
        
        $Url = $CanvasSession.Url
        $Token = $CanvasSession.ApiToken.GetNetworkCredential().Password
        $ApiEndpoint = "/api/v1/courses/$CourseId/assignments/$AssignmentId/submissions"
        $Uri = "$Url/$ApiEndpoint"
        $AuthHeader = @{Authorization = "Bearer $Token"}
        $Request = Invoke-RestMethod -Uri $uri -Method Get -Headers $AuthHeader -Body $Body

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