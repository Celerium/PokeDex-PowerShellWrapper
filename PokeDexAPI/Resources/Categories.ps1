function Get-PokeDexCategories {
<#
    .SYNOPSIS
        Gets Pokémon Categories discovered in the Pokémon World.

    .DESCRIPTION
        The Get-PokeDexCategories cmdlet gets Pokémon Categories discovered in the Pokémon World.

    .EXAMPLE
        Example Response Body:

        [
            "starter",
            "legendary",
            "mythical",
            "ultraBeast",
            "mega"
        ]

    .EXAMPLE
        Get-PokeDexCategories

        This endpoint returns an array of Pokémon Categories discovered in the Pokémon World.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding()]
    Param ()

    $resource_uri = "/categories"

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
