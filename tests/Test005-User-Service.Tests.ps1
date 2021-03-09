﻿# --- Get data for the tests
$JSON = Get-Content .\Variables.json -Raw | ConvertFrom-JSON

# --- Startup
$ConnectionPassword = ConvertTo-SecureString $JSON.Connection.Password -AsPlainText -Force
$Connection = Connect-vROServer -Server $JSON.Connection.vROServer -Username $JSON.Connection.Username -Password $ConnectionPassword -Port $JSON.Connection.Port -IgnoreCertRequirements

# --- Tests
Describe -Name 'User Tests' -Fixture {

    It -Name "Return vRO User Information" -Test {

        $UserInformation = Get-vROUser
        $UserInformation.SolutionUser | Should Not Be $null
    }

}

# --- Cleanup
Disconnect-vROServer -Confirm:$false