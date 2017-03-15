if ($env:APPVEYOR)
{
    $ModuleName = $env:Appveyor_Project_Name
    $Version = $env:APPVEYOR_BUILD_VERSION
}
else
{
    $ModuleName = Split-Path $PSScriptRoot -Leaf
    $Version = "0.1.0"
}

$ModulePath = Join-Path $PSScriptRoot $ModuleName
$ManifestPath = Join-Path $ModulePath "$ModuleName.psd1"
if (Get-Module -Name $ModuleName) { Remove-Module $ModuleName -Force }
Import-Module $ManifestPath -Force

Pester\Describe 'PSScriptAnalyzer' {
    Import-Module -Name PSScriptAnalyzer -Force
    Pester\It "passes Invoke-ScriptAnalyzer" {
        $AnalyzeSplat = @{
            Path        = $ModulePath
            ExcludeRule = "PSUseDeclaredVarsMoreThanAssignments"
            Severity    = "Warning"
        }
        Invoke-ScriptAnalyzer @AnalyzeSplat | Should be $null
    }
}

# test the module manifest - exports the right functions, processes the right formats, and is generally correct
Pester\Describe "Manifest" {
    $Content = Get-Content -Path $ManifestPath -Raw
    $SB = [scriptblock]::Create($Content)
    $ManifestHash = & $SB

    Pester\It "has a valid manifest" {
        {
            $null = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should Not Throw
    }

    Pester\It "has a valid nested module" {
        $ManifestHash.NestedModules | Should Be "$ModuleName.psm1"
    }

    Pester\It "has a valid Description" {
        $ManifestHash.Description | Should Not BeNullOrEmpty
    }

    Pester\It "has a valid guid" {
        $ManifestHash.Guid | Should Be "bd4390dc-a8ad-4bce-8d69-f53ccf8e4163"
    }

    Pester\It "has a valid version" {
        $ManifestHash.ModuleVersion | Should Be $Version
    }

    Pester\It "has a valid copyright" {
        $ManifestHash.CopyRight | Should Not BeNullOrEmpty
    }

    Pester\It 'exports all public functions' {
        $FunctionFiles = Get-ChildItem "$ModulePath\functions" -Filter *.ps1 | Select-Object -ExpandProperty basename
        $FunctionNames = $FunctionFiles
        $ManifestHash.FunctionsToExport | Should Be $FunctionNames
    }
    
    Pester\It 'has a valid license Uri' {
        $ManifestHash.PrivateData.Values.LicenseUri | Should Be "https://github.com/mattmcnabb/Canvas/blob/master/license"
    }
    
    Pester\It 'has a valid project Uri' {
        $ManifestHash.PrivateData.Values.ProjectUri | Should Be "https://github.com/mattmcnabb/Canvas"
    }
    
    Pester\It "gallery tags don't contain spaces" {
        foreach ($Tag in $ManifestHash.PrivateData.Values.tags)
        {
            $Tag -notmatch '\s' | Should Be $true
        }
    }
}

Describe "Functions" {
	InModuleScope "Canvas" {
		Context "Get-LastPageNumber" {
			$Link = '<https://whatev.domain.com/api/v1/accounts/1/users?search_term=username&page=1&per_page=100>; rel="current",<https://whatev.domain.com/api/v1/accounts/1/users?s
earch_term=username&page=1&per_page=100>; rel="first",<https://whatev.domain.com/api/v1/accounts/1/users?search_term=username&page=<placeholder>&per_page=100>; rel="last"'
			$Cases = @(
				@{Link = $Link -replace "<placeholder>", 1; Num = 1},
				@{Link = $Link -replace "<placeholder>", 84; Num = 85}
			)
			It "returns <num>" -TestCases $Cases {
				param ($Link, $Num)
				Get-LastPageNumber -Link $Link | Should Be $Num
			}
		}
	}
}