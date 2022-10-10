<#
    .SYNOPSIS
        Pester tests for functions in the "BaseURI.ps1" file

    .DESCRIPTION
        Pester tests for functions in the "BaseURI.ps1" file which
        is apart of the PokeDexAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1

        Runs a pester test against "BaseURI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1 -Output Detailed

        Runs a pester test against "BaseURI.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='PokeDexAPI'; ModuleVersion='1.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe " Testing [ *-PokeDexBaseURI } functions with [ $FullFileName ]" {

    Context "[ Add-PokeDexBaseURI ] testing functions" {

        It "[ Add-PokeDexBaseURI ] without parameter should return a valid URI" {
            Add-PokeDexBaseURI
            Get-PokeDexBaseURI | Should -Be 'https://pokeapi.glitch.me/v1'
        }

        It "[ Add-PokeDexBaseURI ] should accept a value from the pipeline" {
            'https://celerium.org' | Add-PokeDexBaseURI
            Get-PokeDexBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-PokeDexBaseURI ] with parameter -base_uri should return a valid URI" {
            Add-PokeDexBaseURI -base_uri 'https://celerium.org'
            Get-PokeDexBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-PokeDexBaseURI ] a trailing / from a base_uri should be removed" {
            Add-PokeDexBaseURI -base_uri 'https://celerium.org/'
            Get-PokeDexBaseURI | Should -Be 'https://celerium.org'
        }
    }

    Context "[ Get-PokeDexBaseURI ] testing functions" {

        It "[ Get-PokeDexBaseURI ] should return a valid URI" {
            Add-PokeDexBaseURI
            Get-PokeDexBaseURI | Should -Be 'https://pokeapi.glitch.me/v1'
        }

        It "[ Get-PokeDexBaseURI ] value should be a string" {
            Add-PokeDexBaseURI
            Get-PokeDexBaseURI | Should -BeOfType string
        }
    }

    Context "[ Remove-PokeDexBaseURI ] testing functions" {

        It "[ Remove-PokeDexBaseURI ] should remove the variable" {
            Add-PokeDexBaseURI
            Remove-PokeDexBaseURI
            $PokeDex_Base_URI | Should -BeNullOrEmpty
        }
    }

}