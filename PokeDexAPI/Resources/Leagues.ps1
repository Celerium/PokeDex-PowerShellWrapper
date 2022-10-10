function Get-PokeDexLeagues {
<#
    .SYNOPSIS
        Gets Pokémon Leagues & League data

    .DESCRIPTION
        The Get-PokeDexLeagues cmdlet Pokémon league name and league data

        By default this returns an array of Pokémon League names known to the PokeDex API.

    .PARAMETER names
        A switch statement used to show Pokémon Leagues names in the Pokémon World.

        By default this returns an array of Pokémon Leagues names known to the PokeDex API.

    .PARAMETER slug
        A string used to target specific PokeDex data

        Multiple comma separated values can be defined

        Acceptable values:
            'Indigo', 'Johto', 'Hoenn', 'Sinnoh', 'Unova', 'Kalos', 'Orange'

    .EXAMPLE
        Example Leagues Response Body:

        [
            "Indigo League",
            "Johto League",
            "Hoenn League",
            "Sinnoh League",
            "Unova League",
            "Kalos League",
            "Orange League"
        ]

    .EXAMPLE
        Example Leagues data Response Body:

        {
            "name": "Kalos League",
            "slug": "kalos",
            "region": "Kalos",
            "badgesRequired": 8,
            "badges": [
                "Bug Badge",
                "Cliff Badge",
                "Rumble Badge",
                "Plant Badge",
                "Voltage Badge",
                "Fairy Badge",
                "Psychic Badge",
                "Iceberg Badge"
            ]
        }

    .EXAMPLE
        Get-PokeDexLeagues

        Returns an array of Pokémon League names known to the PokeDex API.

    .EXAMPLE
        Get-PokeDexLeagues -slug Johto

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

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByLeagues')]
        [ValidateSet('Indigo', 'Johto', 'Hoenn', 'Sinnoh', 'Unova', 'Kalos', 'Orange')]
        [string[]]$slug
    )

    Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"

    $rest_results = [System.Collections.Generic.List[object]]::new()

    if ($slug){
        ForEach ($slugId in $slug){
            $resource_uri = "/league/$slugId"

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
        $resource_uri = "/league"

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