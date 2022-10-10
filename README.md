# PokeDex API PowerShell Wrapper

This PowerShell module acts as a wrapper for the [PokeDex](https://github.com/PokeDevs) API by Poke Devs.

---

## Introduction

The PokeDex's API offers users the ability to extract data from PokeDex into third-party reporting tools.
- Full documentation for PokeDex's RESTful API can be found [here](https://pokedevs.gitbook.io/pokedex).

This module serves to abstract away the details of interacting with PokeDex's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using PokeDex's API to create documentation scripts, automation, and integrations.

### Function Naming

PokeDex features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.
- GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `PokeDex` in an attempt to prevent naming problems.

For example, one might access the `/Pokemon` API endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-PokeDexPokemon -slug 151
```

---

## Install & Import

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PokeDexAPI) with the following command:
- :information_source: This module supports PowerShell 5.0+ and should work in PowerShell Core.
```posh
Install-Module -Name PokeDexAPI
```

If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *Master* branch and place the *PokeDexAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

After installation (by either methods), load the module into your workspace:

```posh
Import-Module PokeDexAPI
```

---
## Initial Setup

After importing this module, you will need to configure the *base URI* which is used to to talk with the PokeDex API.

1. Run `Add-PokeDexBaseURI`
   - By default, PokeDex's `https://pokeapi.glitch.me/v1` uri is used.
   - If you have your own API gateway or proxy, you may put in your own custom uri by specifying the `-base_uri` parameter:
     -  `Add-PokeDexBaseURI -base_uri http://myapi.gateway.example.com`
<br><br>

[optional]
1. Run `Export-PokeDexModuleSettings`
   - This will create a config file at `%UserProfile%\PokeDexAPI` that holds the *base uri* & *JSON* information.
   - Next time you run `Import-Module -Name PokeDexAPI`, this configuration file will automatically be loaded.

---
## Usage

Calling an API resource is as simple as running `Get-PokeDex<resourceName>`
   - The following is a table of supported functions and their corresponding API resources:
   - Table entries with [ `-` ] indicate that the functionality is NOT supported by the PokeDex API at this time.

| API Resource       | Create    | Read                             | Update    | Delete    |
| -----------------  | --------- | -------------------------------- | --------- | --------- |
| Categories         | -         | `Get-PokeDexCategories`          | -         | -         |
| EggGroups          | -         | `Get-PokeDexEggGroups`           | -         | -         |
| EvolutionStones    | -         | `Get-PokeDexEvolutionStones`     | -         | -         |
| Leagues            | -         | `Get-PokeDexLeagues`             | -         | -         |
| Meta               | -         | `Get-PokeDexMeta`                | -         | -         |
| PokeDex *          | -         | `Get-PokeDexPokeDex`             | -         | -         |
| Pokemon            | -         | `Get-PokeDexPokemon`             | -         | -         |
| Types              | -         | `Get-PokeDexTypes`               | -         | -         |

:warning: `Get-PokeDex` is a special case. It is **NOT** an endpoint in PokeDex API, but is included to make it easier to get PokeDex API data from one function rather than multiple.

Each `Get-PokeDex*` function will respond with the raw data that the PokeDex's API provides.

---
## Help :blue_book:

  - A full list of functions can be retrieved by running `Get-Command -Module PokeDexAPI`.
  - Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-PokeDexPokemon
Get-Help Get-PokeDexPokemon -Full
```