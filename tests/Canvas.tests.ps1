$ProjectPath = Split-Path $PSScriptRoot

if ($env:APPVEYOR)
{
    $ModuleName = $env:Appveyor_Project_Name
    $Version = $env:APPVEYOR_BUILD_VERSION
}
else
{
    $ModuleName = Split-Path $ProjectPath -Leaf
    $Version = "0.1.0"
}

$ModulePath = Join-Path $ProjectPath $ModuleName
Import-Module $ModulePath -Force

Describe "Functions" {
    InModuleScope "Canvas" {
        Context "Get-NextPageNumber" {
            $Link = '<https://whatev.domain.com/api/v1/accounts/1/users?search_term=username&page=1&per_page=100>; rel="current",<https://whatev.domain.com/api/v1/accounts/1/users?search_term=username&page=<placeholder>&per_page=100>; rel="next",<https://whatev.domain.com/api/v1/accounts/1/users?search_term=username&page=1&per_page=100>; rel="first"'
            $Cases = @(
                @{Link = $Link -replace "<placeholder>", 1; Num = 1},
                @{Link = $Link -replace "<placeholder>", 85; Num = 85}
            )
            It "returns <num>" -TestCases $Cases {
                param ($Link, $Num)
                Get-NextPageNumber -Link $Link | Should Be $Num
            }
        }
    }
}