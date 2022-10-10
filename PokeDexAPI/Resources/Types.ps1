function Get-PokeDexTypes {
<#
    .SYNOPSIS
        Gets Pokémon Types discovered in the Pokémon World.

    .DESCRIPTION
        The Get-PokeDexTypes cmdlet gets Pokémon Types discovered in the Pokémon World.

    .EXAMPLE
        Example Response Body:

        [
            "Bug",
            "Dark",
            "Dragon",
            "Electric",
            "Fairy",
            "Fighting",
            "Fire",
            "Flying",
            "Ghost",
            "Grass",
            "Ground",
            "Ice",
            "Normal",
            "Poison",
            "Psychic",
            "Rock",
            "Steel",
            "Water"
        ]

    .EXAMPLE
        Get-PokeDexTypes

        This endpoint returns an array of Pokémon Types discovered in the Pokémon World.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding()]
    Param ()

    $resource_uri = "/types"

    Write-Verbose "Querying  [ $($PokeDex_Base_URI + $resource_uri) ]"

    try {
        $rest_output = Invoke-RestMethod -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers -ErrorAction Stop -ErrorVariable web_error
    } catch {
        Write-Error $_
    } finally {
        #Future Use
    }

    $data = @{}
    $data = $rest_output
    return $data

}
