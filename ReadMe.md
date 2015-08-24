Style Guidelines
- Any API object needs it's own PS data type
- Each data type should get the CanvasSession property added to support piping
- After creating a new data type, make sure you set up a format entry
- Parameter names should be abstracted from the property names in the API (account_id becomes $AccountId)
- 120 character soft line limit
- C# style guidelines adapted to Powershell
- cmdlet help should include a link to that API endpoint doc
- general PS style guidelines


To-Do:
- Canvas Sessions are now in a stack ($CanvasSessions). Used a dynamic parameter but this doesn't work well
for piping by property. Reverted to piped parameter. This should be sufficient.
- Update Canvas function snippet to enforce uniformity

Current types:
- Canvas.Session
- Canvas.User
- Canvas.Course
- Canvas.Account



Parameter Naming Conventions
- Parameters that take a type in the "Canvas" namespace should match the type name. For example, if a parameter
accepts the type "Canvas.Session," it should be named "$CanvasSession."
- Cmdlets that take pipeline input typically have two parameter sets: "Named" and "Piped." For Piped sets, parameter
names should match the attribute name of the returned object. For Named sets, the parameter name should be 
abstracted to match Powershell naming conventions.

Example:

   ``` Powershell
      [CmdletBinding(DefaultParameterSetName='Named')]
      param
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
      
      switch ($PSCmdlet.ParameterSetName)
      {
          'Piped' {$CourseId = $CanvasCourse.Id}
      }
   ```
