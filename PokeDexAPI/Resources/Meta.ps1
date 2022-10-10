function Get-PokeDexMeta {
<#
    .SYNOPSIS
        Gets PokeDex API meta data

    .DESCRIPTION
        The Get-PokeDexMeta cmdlet gets PokeDex API meta data for the APIs Info & status endpoints.

        By default the info endpoint is retrieved

    .PARAMETER slug
        A string used to target specific PokeDex data

        Acceptable options:
            info, stats

        By default the info endpoint is retrieved

    .PARAMETER rateLimiting
        A switch statement used to show the current rate limit data from the PokeDex API.

    .EXAMPLE
        Example Response Body:

        {
            "title": "Pokédex API",
            "baseURL": "https://pokeapi.glitch.me",
            "resourceURL": "https://pokeres.bastionbot.org",
            "versions": [
                "/v1"
            ],
            "author": "Sankarsan Kampa"
        }

    .EXAMPLE
        Get-PokeDexMeta

        Meta data from the PokeDex info endpoint is retrieved.

    .EXAMPLE
        Get-PokeDexMeta -slug info

        Meta data from the PokeDex info endpoint is retrieved.

    .EXAMPLE
        Get-PokeDexMeta -rateLimiting

        Shows the current rate limit data from the PokeDex API.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [ValidateSet('info','stats')]
        [string]$slug,

        [Parameter(Mandatory = $false, ParameterSetName = 'indexByRequest')]
        [switch]$rateLimiting

    )

    Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"

    switch ($PSCmdlet.ParameterSetName) {
        'index'             {if ($slug){$resource_uri = "/$slug"}else{$resource_uri = "/info"}}
        'indexByRequest'    {$resource_uri = "/stats"}
    }

    $PokeDex_Base_URI = 'https://pokeapi.glitch.me'

    if ($PSCmdlet.ParameterSetName -eq 'index'){

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
        return $data
    }

    if ($rateLimiting){

        Write-Verbose ''
        Write-Verbose "Querying  [ $($PokeDex_Base_URI + $resource_uri) ]"

        try {
            $rest_output = Invoke-WebRequest -Method Get -Uri ( $PokeDex_Base_URI + $resource_uri ) -Headers $PokeDex_Headers -ErrorAction Stop -ErrorVariable web_error
        } catch {
            Write-Error $_
        } finally {
            #Future Use
        }

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

        return $rest_results
    }

}
