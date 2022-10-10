function Export-PokeDexModuleSettings {
<#
    .SYNOPSIS
        Exports the PokeDex BaseURI & JSON configuration information to file.

    .DESCRIPTION
        The Export-PokeDexModuleSettings cmdlet exports the PokeDex BaseURI, & JSON configuration information to file.

    .PARAMETER PokeDexConfPath
        Define the location to store the PokeDex configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokeDexAPI

    .PARAMETER PokeDexConfFile
        Define the name of the PokeDex configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-PokeDexModuleSettings

        Validates that the BaseURI & JSON depth are set then exports their values
        to the current user's PokeDex configuration file located at:
            $env:USERPROFILE\PokeDexAPI\config.psd1

    .EXAMPLE
        Export-PokeDexModuleSettings -PokeDexConfPath C:\PokeDexAPI -PokeDexConfFile MyConfig.psd1

        Validates that the BaseURI & JSON depth are set then exports their values
        to the current user's PokeDex configuration file located at:
            C:\PokeDexAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokeDexConfPath = "$($env:USERPROFILE)\PokeDexAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$PokeDexConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($PokeDex_Base_URI -and $PokeDex_JSON_Conversion_Depth) {
        New-Item -ItemType Directory -Force -Path $PokeDexConfPath | ForEach-Object {$_.Attributes = 'hidden'}
@"
    @{
        PokeDex_Base_URI = '$PokeDex_Base_URI'
        PokeDex_JSON_Conversion_Depth = '$PokeDex_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($PokeDexConfPath+"\"+$PokeDexConfFile) -Force
    }
    else {
        Write-Error $_
        Write-Error "Failed to export PokeDex Module settings to [ $PokeDexConfPath\$PokeDexConfFile ]"
    }
}

function Import-PokeDexModuleSettings {
<#
    .SYNOPSIS
        Imports the PokeDex BaseURI & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-PokeDexModuleSettings cmdlet imports the PokeDex BaseURI & JSON configuration
        information stored in the PokeDex configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokeDexAPI

    .PARAMETER PokeDexConfPath
        Define the location to store the PokeDex configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokeDexAPI

    .PARAMETER PokeDexConfFile
        Define the name of the PokeDex configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-PokeDexModuleSettings

        Validates that the configuration file created with the Export-PokeDexModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the PokeDex configuration file is:
            $env:USERPROFILE\PokeDexAPI\config.psd1

    .EXAMPLE
        Import-PokeDexModuleSettings -PokeDexConfPath C:\PokeDexAPI -PokeDexConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-PokeDexModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the PokeDex configuration file in this example is:
            C:\PokeDexAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokeDexConfPath = "$($env:USERPROFILE)\PokeDexAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$PokeDexConfFile = 'config.psd1'
    )

    if( test-path ($PokeDexConfPath+"\"+$PokeDexConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $PokeDexConfPath -FileName $PokeDexConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-PokeDexBaseURI $tmp_config.PokeDex_Base_URI

            Set-Variable -Name "PokeDex_JSON_Conversion_Depth" -Value $tmp_config.PokeDex_JSON_Conversion_Depth `
                        -Scope global -Force

        Write-Host "PokeDexAPI Module configuration loaded successfully from [ $PokeDexConfPath\$PokeDexConfFile ]" -ForegroundColor Green

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $PokeDexConfPath\$PokeDexConfFile ]"
        Write-Verbose "Please run Add-PokeDexBaseURI to get started."

            Set-Variable -Name "PokeDex_Base_URI" -Value "https://pokeapi.glitch.me/v1" -Option ReadOnly -Scope global -Force
            Set-Variable -Name "PokeDex_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}

function Remove-PokeDexModuleSettings {
<#
    .SYNOPSIS
        Removes the stored PokeDex configuration folder.

    .DESCRIPTION
        The Remove-PokeDexModuleSettings cmdlet removes the PokeDex folder and its files.
        This cmdlet also has the option to remove sensitive PokeDex variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\PokeDexAPI

    .PARAMETER PokeDexConfPath
        Define the location of the PokeDex configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\PokeDexAPI

    .PARAMETER AndVariables
        Define if sensitive PokeDex variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-PokeDexModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the PokeDex configuration folder is:
            $env:USERPROFILE\PokeDexAPI

    .EXAMPLE
        Remove-PokeDexModuleSettings -PokeDexConfPath C:\PokeDexAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive PokeDex variables exist then they are removed as well.

        The location of the PokeDex configuration folder in this example is:
            C:\PokeDexAPI

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/PokeDex-PowerShellWrapper
        https://pokedevs.gitbook.io/pokedex/
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokeDexConfPath = "$($env:USERPROFILE)\PokeDexAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if(Test-Path $PokeDexConfPath)  {

        Remove-Item -Path $PokeDexConfPath -Recurse -Force

        If ($AndVariables) {
            if ($PokeDex_Base_URI) {
                Remove-Variable -Name "PokeDex_Base_URI" -Scope global -Force
            }
        }

            if (!(Test-Path $PokeDexConfPath)) {
                Write-Host "The PokeDexAPI configuration folder has been removed successfully from [ $PokeDexConfPath ]" -ForegroundColor Green
            }
            else {
                Write-Error "The PokeDexAPI configuration folder could not be removed from [ $PokeDexConfPath ]"
            }

    }
    else {
        Write-Warning "No configuration folder found at [ $PokeDexConfPath ]"
    }
}