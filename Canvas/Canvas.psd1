@{
	NestedModules = "Canvas.psm1"
	ModuleVersion = "0.1.0"
	GUID = "bd4390dc-a8ad-4bce-8d69-f53ccf8e4163"
	Author = "Matt McNabb"
	Copyright = "(c) 2017 . All rights reserved."
	Description = "A PowerShell module for managing aspects of the Canvas Learning Management System using its' REST API"
	PowerShellVersion = "5.0"
	FunctionsToExport = @(
		"Get-CanvasUser"
	)

	PrivateData = @{
        PSData = @{
            Tags = @("Canvas","Education","K-12","REST","Learning","LMS")
            LicenseUri = "https://github.com/mattmcnabb/Canvas/blob/master/license"
            ProjectUri = "https://github.com/mattmcnabb/Canvas"
            # ReleaseNotes = ""
        }
    }
}
