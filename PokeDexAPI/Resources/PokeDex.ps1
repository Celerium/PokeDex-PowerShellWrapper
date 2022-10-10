function Get-PokeDex {
<#
    .SYNOPSIS
        Gets Pokemon objects from all PokeDex endpoints

    .DESCRIPTION
        The Get-PokeDex cmdlet in an all-in-one function that gets Pokémon objects from all PokeDex endpoints

        By default meta data about the PokeDex API is returned if no parameters are defined

    DYNAMIC PARAMETER slug
        A string used to target specific PokeDex data

        Multiple comma separated values can be defined

        Compatible with the following parameters:
            Pokemon, EvolutionStones, Leagues

    .PARAMETER Pokemon
        A switch statement used to target specific Pokemon data

        Works with the dynamic [ slug ] parameter

        If the [ slug ] parameter is NOT defined then an object
        containing the count of Pokémon in each generation and
        the total number of Pokémon in the Pokémon World is returned.

    .PARAMETER Categories
        A switch statement used to show Pokémon Categories in the Pokémon World.

    .PARAMETER EggGroups
        A switch statement used to show Pokémon Egg Groups in the Pokémon World.

    .PARAMETER EvolutionStones
        A switch statement used to target specific EvolutionStone data

        Works with the dynamic [ slug ] parameter

        If the [ slug ] parameter is NOT defined then an object
        containing the names of Pokémon Evolution Stone is returned.

    .PARAMETER Leagues
        A switch statement used to target specific League data

        Works with the dynamic [ slug ] parameter

        If the [ slug ] parameter is NOT defined then an object
        containing the names of Pokémon Leagues is returned.

    .PARAMETER Types
        A switch statement used to show Pokémon Types in the Pokémon World.

    .PARAMETER Meta
        A string used to target specific PokeDex API data

        Acceptable options:
            info, stats

        By default the info endpoint is retrieved

    .PARAMETER rateLimiting
        A switch statement used to show the current rate limit data from the PokeDex API.

    .EXAMPLE
        Get-PokeDex

        Meta data from the PokeDex info endpoint is retrieved.

    .EXAMPLE
        Get-PokeDex -Pokemon

        Returns a Pokémon Counts object containing the number of Pokémon in each generation and the total number of Pokémon in the Pokémon World.

    .EXAMPLE
        Get-PokeDex -Pokemon -slug 120,121,122

        Returns an array of Pokémon objects containing all the forms of the Pokémon specified by the Pokémon name or id.

    .EXAMPLE
        Get-PokeDex -Categories

        Returns an array of Pokémon Categories discovered in the Pokémon World.

    .EXAMPLE
        Get-PokeDex -EggGroups

        Returns an array of Pokémon Egg Groups discovered in the Pokémon World.

    .EXAMPLE
        Get-PokeDex -EvolutionStones

        Returns an array of Pokémon Evolution Stone names discovered in the Pokémon World.

    .EXAMPLE
        Get-PokeDex -EvolutionStones -slug fire

        Returns a Evolution Stone object containing the details about the evolution stone.

        Acceptable values:
            'Fire', 'Water', 'Thunder', 'Leaf', 'Moon', 'Sun', 'Shiny', 'Dusk', 'Dawn', 'Ice'

    .EXAMPLE
        Get-PokeDex -Leagues

        Returns an array of Pokémon League names known to us.

    .EXAMPLE
        Get-PokeDex -Leagues -slug fire

        Returns a Pokémon League object containing the details about the league.

        Acceptable values:
            'Indigo', 'Johto', 'Hoenn', 'Sinnoh', 'Unova', 'Kalos', 'Orange'

    .EXAMPLE
        Get-PokeDex -Types

        Returns an array of Pokémon Types discovered in the Pokémon World.

    .EXAMPLE
        Get-PokeDex -Meta info

        Returns basic information about the Pokédex API.

        This is the default parameter set output

    .EXAMPLE
        Get-PokeDex -Meta stats

        Returns basic statistics of the Pokédex API.

    .EXAMPLE
        Get-PokeDex -rateLimiting

        Shows the current rate limit data from the PokeDex API.

    .NOTES
        Cleanup, understand, & simplify dynamic slug parameter

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'indexByMeta')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'indexByPokemon')]
        [switch]$Pokemon,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByCategories')]
        [switch]$Categories,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByEggGroups')]
        [switch]$EggGroups,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByEvolutionStones')]
        [switch]$EvolutionStones,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByLeagues')]
        [switch]$Leagues,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByTypes')]
        [switch]$Types,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByMeta')]
        [ValidateSet('info', 'stats')]
        [string]$Meta = 'info',

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByRequest')]
        [switch]$rateLimiting
    )

    DynamicParam {
        $ParameterName = 'slug'
        $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
        $ParameterAttribute.Mandatory = $false
        $AttributeCollection.Add($ParameterAttribute)

        if($PsCmdlet.ParameterSetName -eq 'indexByPokemon'){
            $ValidateNotNullOrEmptyAttribute = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
            $AttributeCollection.Add($ValidateNotNullOrEmptyAttribute)

            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string[]], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
            return $RuntimeParameterDictionary
        }
        elseif ($PsCmdlet.ParameterSetName -eq 'indexByEvolutionStones' -or $PsCmdlet.ParameterSetName -eq 'indexByLeagues'){
            switch ($PsCmdlet.ParameterSetName) {
                'indexByEvolutionStones'	{ $ValidateSet = 'Fire', 'Water', 'Thunder', 'Leaf', 'Moon', 'Sun', 'Shiny', 'Dusk', 'Dawn', 'Ice'}
                'indexByLeagues'	        { $ValidateSet = 'Indigo', 'Johto', 'Hoenn', 'Sinnoh', 'Unova', 'Kalos', 'Orange'}
            }
            $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($ValidateSet)
            $AttributeCollection.Add($ValidateSetAttribute)

            $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string[]], $AttributeCollection)
            $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
            return $RuntimeParameterDictionary
        }
        else{$null}
    }

    begin{
        Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"
    }

    process {

        $slug = $PsBoundParameters[$ParameterName]
        $rest_results = [System.Collections.Generic.List[object]]::new()

        if ($slug){
            ForEach ($slugId in $slug){

                switch ($PSCmdlet.ParameterSetName) {
                    'indexByPokemon'            {   $resource_uri = "/pokemon/$slugId" }
                    'indexByEvolutionStones'    {   $resource_uri = "/evolution-stone/$slugId" }
                    'indexByLeagues'            {   $resource_uri = "/league/$slugId" }
                }

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

            switch ($PSCmdlet.ParameterSetName) {
                'indexByPokemon'         {   $resource_uri = "/pokemon/counts" }
                'indexByCategories'      {   $resource_uri = "/categories" }
                'indexByEggGroups'       {   $resource_uri = "/egg-groups" }
                'indexByEvolutionStones' {   $resource_uri = "/evolution-stone/" }
                'indexByLeagues'         {   $resource_uri = "/league" }
                'indexByTypes'           {   $resource_uri = "/types" }
                'indexByMeta'            {   $PokeDex_Base_URI = 'https://pokeapi.glitch.me'
                                            $resource_uri = "/$Meta"
                                        }
                'indexByRequest'         {   $PokeDex_Base_URI = 'https://pokeapi.glitch.me'
                                            $resource_uri = "/stats"
                                        }
            }

            Write-Verbose ''
            Write-Verbose "Querying  [ $($PokeDex_Base_URI + $resource_uri) ]"

            try {

                if ($PSCmdlet.ParameterSetName -ne 'indexByRequest'){
                    $rest_output = Invoke-RestMethod -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers  -ErrorAction Stop -ErrorVariable web_error
                }
                else{
                    $rest_output = Invoke-WebRequest -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers -ErrorAction Stop -ErrorVariable web_error
                }

            } catch {
                Write-Error $_
            } finally {
                #Future Use
            }

            if ($PSCmdlet.ParameterSetName -eq 'indexByRequest'){
                $data = @{}
                $data = $rest_output
                $rest_results = [System.Collections.Generic.List[object]]::new()

                $rateLimitResults = [PSCustomObject]@{
                    StatusCode              = $data.StatusCode
                    StatusDescription       = $data.StatusDescription
                    Connection              = $($data.headers['Connection'])
                    'x-ratelimit-limit'     = $($data.headers['x-ratelimit-limit'])
                    'x-ratelimit-remaining' = $($data.headers['x-ratelimit-remaining'])
                    'x-ratelimit-reset'     = $($data.headers['x-ratelimit-reset'])
                    'developer'             = $($data.headers['developer'])
                    'developer-url'         = $($data.headers['developer-url'])
                    'Content-Length'        = $($data.headers['Content-Length'])
                    'Content-Type'          = $($data.headers['Content-Type'])
                    'Date'                  = $($data.headers['Date'])
                    'ETag'                  = $($data.headers['ETag'])
                }
                $rest_results.Add($rateLimitResults) > $null
            }
            else{
                $data = @{}
                $data = $rest_output
                $rest_results.Add($data) > $null
            }
        }

        return $rest_results

    }

}
