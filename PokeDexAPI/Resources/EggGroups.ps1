function Get-PokeDexEggGroups {
<#
    .SYNOPSIS
        Gets Pokémon Egg Groups discovered in the Pokémon World.

    .DESCRIPTION
        The Get-PokeDexEggGroups cmdlet gets Pokémon Egg Groups discovered in the Pokémon World.

    .EXAMPLE
        Example Response Body:

        [
            "Bug",
            "Ditto",
            "Dragon",
            "Fairy",
            "Field",
            "Flying",
            "Grass",
            "Gender unknown",
            "Human-Like",
            "Mineral",
            "Monster",
            "Amorphous",
            "Undiscovered",
            "Water 1",
            "Water 2",
            "Water 3"
        ]

    .EXAMPLE
        Get-PokeDexEggGroups

        This endpoint returns an array of Pokémon Egg Groups discovered in the Pokémon World.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding()]
    Param ()

    $resource_uri = "/egg-groups"

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
