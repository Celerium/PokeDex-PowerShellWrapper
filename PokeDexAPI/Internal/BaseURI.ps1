function Add-PokeDexBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the PokeDex API connection.

    .DESCRIPTION
        The Add-PokeDexBaseURI cmdlet sets the base URI which is later used to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the PokeDex API connection using PokeDex's URI or a custom URI.

    .EXAMPLE
        Add-PokeDexBaseURI

        The base URI will use https://pokeapi.glitch.me/v1 which is PokeDex's default URI.

    .EXAMPLE
        Add-PokeDexBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to PokeDex's API.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = 'https://pokeapi.glitch.me/v1'

    )

    # Trim superfluous forward slash from address (if applicable)
    if ($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    Set-Variable -Name "PokeDex_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force
}

function Get-PokeDexBaseURI {
<#
    .SYNOPSIS
        Shows the PokeDex base URI global variable.

    .DESCRIPTION
        The Get-PokeDexBaseURI cmdlet shows the PokeDex base URI global variable value.

    .EXAMPLE
        Get-PokeDexBaseURI

        Shows the PokeDex base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [cmdletbinding()]
    Param ()

    if ($PokeDex_Base_URI){
        $PokeDex_Base_URI
    }
    Else{
        Write-Warning "The PokeDex base URI is not set. Run Add-PokeDexBaseURI to set the base URI."
    }
}

function Remove-PokeDexBaseURI {
<#
    .SYNOPSIS
        Removes the PokeDex base URI global variable.

    .DESCRIPTION
        The Remove-PokeDexBaseURI cmdlet removes the PokeDex base URI global variable.

    .EXAMPLE
        Remove-PokeDexBaseURI

        Removes the PokeDex base URI global variable.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [cmdletbinding()]
    Param ()

    if ($PokeDex_Base_URI) {
        Remove-Variable -Name "PokeDex_Base_URI" -Scope global -Force
    }
    Else{
        Write-Warning "The PokeDex base URI variable is not set. Nothing to remove"
    }
}

New-Alias -Name Set-PokeDexBaseURI -Value Add-PokeDexBaseURI