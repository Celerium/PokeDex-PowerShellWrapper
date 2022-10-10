function Get-PokeDexEvolutionStones {
<#
    .SYNOPSIS
        Gets Pokémon EvolutionStone & EvolutionStone data

    .DESCRIPTION
        The Get-EvolutionStone cmdlet gets Pokémon EvolutionStone & EvolutionStone data

        By default this returns an array of Pokémon EvolutionStone names known to the PokeDex API.

    .PARAMETER names
        A switch statement used to show Pokémon Evolution Stone names in the Pokémon World.

        By default this returns an array of Pokémon EvolutionStone names known to the PokeDex API.

    .PARAMETER slug
        A string used to target specific PokeDex data

        Multiple comma separated values can be defined

        Acceptable values:
            'Fire', 'Water', 'Thunder', 'Leaf', 'Moon', 'Sun', 'Shiny', 'Dusk', 'Dawn', 'Ice'

    .EXAMPLE
        Example EvolutionStone Response Body:

        [
            "Fire Stone",
            "Water Stone",
            "Thunder Stone",
            "Leaf Stone",
            "Moon Stone",
            "Sun Stone",
            "Shiny Stone",
            "Dusk Stone",
            "Dawn Stone",
            "Ice Stone"
        ]

    .EXAMPLE
        Example EvolutionStone data Response Body:

        {
            "name": "Dusk Stone",
            "aka": "Darkness Stone",
            "slug": "dusk",
            "effects": [
                "Causes Murkrow to evolve into Honchkrow.",
                "Causes Misdreavus to evolve into Mismagius.",
                "Causes Lampent to evolve into Chandelure.",
                "Causes Doublade to evolve into Aegislash."
            ],
            "sprite": "https://pokeres.bastionbot.org/images/evolution-stones/dusk-stone.png"
        }

    .EXAMPLE
        Get-EvolutionStone

        Returns an array of Pokémon League names known to the PokeDex API.

    .EXAMPLE
        Get-EvolutionStone -slug Johto

        Returns a Pokémon League object containing the details about the league.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [switch]$Names,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByEvolutionStones')]
        [ValidateSet('Fire', 'Water', 'Thunder', 'Leaf', 'Moon', 'Sun', 'Shiny', 'Dusk', 'Dawn', 'Ice')]
        [string[]]$slug
    )

    Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"

    $rest_results = [System.Collections.Generic.List[object]]::new()

    if ($slug){
        ForEach ($slugId in $slug){
            $resource_uri = "/evolution-stone/$slugId"

            Write-Verbose ''
            Write-Verbose "Querying  [ $($PokeDex_Base_URI + $resource_uri) ]"

            try {
                $rest_output = Invoke-RestMethod -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers  -ErrorAction Stop -ErrorVariable web_error
            } catch {
                Write-Error $_
            } finally {
                #Future Use
            }

            $data = @{}
            $data = $rest_output
            $rest_results.Add($data) > $null
        }
    }
    else{
        $resource_uri = "/evolution-stone"

        try {
            $rest_output = Invoke-RestMethod -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers  -ErrorAction Stop -ErrorVariable web_error
        } catch {
            Write-Error $_
        } finally {
            #Future Use
        }

        $data = @{}
        $data = $rest_output
        $rest_results.Add($data) > $null
    }

    return $rest_results

}
