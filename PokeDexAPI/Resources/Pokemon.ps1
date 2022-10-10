function Get-PokeDexPokemon {
<#
    .SYNOPSIS
        Gets Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .DESCRIPTION
        The Get-PokeDexPokemon cmdlet gets Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .PARAMETER slug
        A string used to target specific PokeDex data

        Multiple comma separated values can be defined

    .PARAMETER count
        Returns a Pokémon Counts object containing the number of Pokémon in each generation and the total number of Pokémon in the Pokémon World.

    .EXAMPLE
        Example Pokémon Response Body:

        [
            {
                "number": "658",
                "name": "Greninja",
                "species": "Ninja",
                "types": [
                "Water",
                "Dark"
                ],
                "abilities": {
                "normal": [
                    "Torrent"
                ],
                "hidden": [
                    "Protean"
                ]
                },
                "eggGroups": [
                "Water 1"
                ],
                "gender": [
                87.5,
                12.5
                ],
                "height": "4'11\"",
                "weight": "88.2 lbs.",
                "family": {
                "id": 331,
                "evolutionStage": 3,
                "evolution-line": [
                    "Froakie",
                    "Frogadier",
                    "Greninja"
                ]
                },
                "starter": false,
                "legendary": false,
                "mythical": false,
                "ultraBeast": false,
                "mega": false,
                "gen": 6,
                "sprite": "https://pokeres.bastionbot.org/images/pokemon/658.png",
                "description": "It creates throwing stars out of compressed water. When it spins them and throws them at high speed, these stars can split metal in two."
            },
            {
                "number": "658",
                "name": "Ash-Greninja",
                "species": "Ninja",
                "types": [
                "Water",
                "Dark"
                ],
                "abilities": {
                "normal": [
                    "Torrent"
                ],
                "hidden": [
                    "Battle Bond"
                ]
                },
                "eggGroups": [
                "Water 1"
                ],
                "gender": [
                87.5,
                12.5
                ],
                "height": "4'11\"",
                "weight": "88.2 lbs.",
                "family": {
                "id": 331,
                "evolutionStage": 3,
                "evolution-line": [
                    "Froakie",
                    "Frogadier",
                    "Greninja"
                ]
                },
                "starter": false,
                "legendary": false,
                "mythical": false,
                "ultraBeast": false,
                "mega": false,
                "gen": 6,
                "sprite": "https://pokeres.bastionbot.org/images/pokemon/658-ash.png",
                "description": "It creates throwing stars out of compressed water. When it spins them and throws them at high speed, these stars can split metal in two."
            }
        ]

    .EXAMPLE
        Example Pokémon Counts Response Body:

        {
            "gen1": 151,
            "gen2": 100,
            "gen3": 135,
            "gen4": 107,
            "gen5": 156,
            "gen6": 72,
            "gen7": 86,
            "total": 807
        }

    .EXAMPLE
        Get-PokeDexPokemon -slug 120

        Returns an array of Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .EXAMPLE
        Get-PokeDexPokemon -slug 120,121,122

        Returns an array of Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .EXAMPLE
        Get-PokeDexPokemon -counts

        Returns an array of Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [switch]$Count,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'indexByPokemon')]
        [string[]]$slug
    )

    Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"

    $rest_results = [System.Collections.Generic.List[object]]::new()

    if ($slug){
        ForEach ($slugId in $slug){
            $resource_uri = "/pokemon/$slugId"

            Write-Verbose ''
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
            $rest_results.Add($data) > $null
        }
    }
    else{
        $resource_uri = "/pokemon/counts"

        try {
            $rest_output = Invoke-RestMethod -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers -ErrorAction Stop -ErrorVariable web_error
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
