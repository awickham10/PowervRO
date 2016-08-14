﻿function Add-vROWorkflowPermission {
<#
    .SYNOPSIS
    Add a Permission to a vRO Workflow
    
    .DESCRIPTION
    Add a Permission to a vRO Workflow
    
    .PARAMETER Id
    Workflow Id

    .PARAMETER Principal
    Specify the Permission Principal. Needs to be in the format user@domain or domain\user

    .PARAMETER Rights
    Specify the Permission Rights

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.
    
    .EXAMPLE
    Add-vROWorkflowPermission -Id '3f92d2dc-a9fa-4323-900b-ef97196184ea' -Principal vRO_Users@vrademo.local -Rights 'View','Execute','Inspect'

    .EXAMPLE
    $Permissions = Get-vROWorkflowPermission -Id '3f92d2dc-a9fa-4323-900b-ef97196184ea'
    Get-vROWorkflow -Id '5af6c1fd-3d12-4418-8542-0afad165cc08' | Add-vROWorkflowPermission -Principal $Permissions[0].Principal -Rights $Permissions[0].Rights
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$Principal,  
    
    [parameter(Mandatory=$true)]
    [ValidateSet("View","Execute","Inspect","Edit","Admin")]
    [String[]]$Rights
    )

    begin {

        # --- Break out the Username and Domain from the Principal
        if ($Principal -match "@"){

            $Username = ($Principal -split "@")[0]
            $Domain = ($Principal -split "@")[1]
        }
        elseif ($Principal -match "\\"){

            $Username = ($Principal -split "\\")[1]
            $Domain = ($Principal -split "\\")[0]
        }
        else {

            throw "Principal needs to be in the format user@domain or domain\user"
        }

        # --- Convert Rights to API required digit(s)
        $APIRights = @()

        switch ($Rights)
        {
            "View" {$APIRights += "r"}
            "Execute" {$APIRights += "x"}
            "Inspect" {$APIRights += "i"}
            "Edit" {$APIRights += "c"}
            "Admin" {$APIRights += "a"}

            Default {}
        }
    }

    process {

        foreach ($WorkflowId in $Id){
                
            try {

                if ($PSCmdlet.ShouldProcess($WorkflowId)){

                    # --- Create JSON Body
                    $Body = @"
    {
      "permissions": [
        {
          "permission": {
            "principal": "$($Domain)\\$($Username)",
            "rights": "$($APIRights -join "")"
          }
        }
      ]
    }
"@
                    # --- Send REST call and process results            
                    $URI = "/vco/api/workflows/$($WorkflowId)/permissions"

                    Invoke-vRORestMethod -Method POST -Uri $URI -Body $Body -Verbose:$VerbosePreference | Out-Null
        
                    # --- Output the Successful Result
                    Get-vROWorkflowPermission -Id $WorkflowId | Where-Object {$_.Principal -match $Username}
                }
            }
            catch [Exception]{

                throw
            }
        }
    }

    end {

    }
}