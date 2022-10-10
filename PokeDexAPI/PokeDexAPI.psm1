$PokeDex_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$PokeDex_Headers.Add("User-Agent", 'PokeDexAPI-PoSH (https://github.com/Celerium/PokeDex-PowerShellWrapper, v1.0.0)')
$PokeDex_Headers.Add("Authorization", 'None')
$PokeDex_Headers.Add("Content-Type", 'application/json')

Set-Variable -Name "PokeDex_Headers" -Value $PokeDex_Headers -Scope global

Import-PokeDexModuleSettings