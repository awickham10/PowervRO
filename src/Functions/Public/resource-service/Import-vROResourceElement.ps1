﻿function Import-vROResourceElement {
<#
    .SYNOPSIS
    Imports a resource element in a given category.

    .DESCRIPTION
    Imports a resource element in a given category.

    .PARAMETER CategoryId
    The name of the resource element category

    .PARAMETER File
    The resouce file

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Get-ChildItem -Path C:\Resources\* | Import-vROResourceElement -CategoryId "36cd783f-e858-4783-9273-06d11defc8b0" -Confirm:$false

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [String]$CategoryId,

    [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelinebyPropertyName=$true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$File

    )

    begin {

        #Set Set Line Feed
        $LF = "`r`n"

    }

    process {

        foreach ($FilePath in $File){

            $FileInfo = [System.IO.FileInfo](Resolve-Path $FilePath).Path

            try {

                # --- Create the multi-part form
                $Boundary = [guid]::NewGuid().ToString()
                $FileBin = [System.IO.File]::ReadAllBytes($FileInfo.FullName)
                $Encoding = [System.Text.Encoding]::GetEncoding("iso-8859-1")
                $EncodedFile = $Encoding.GetString($FileBin)

                $Form = (
                    "--$($Boundary)",
                    "Content-Disposition: form-data; name=`"file`"; filename=`"$($FileInfo.Name)`"",
                    "Content-Type:application/octet-stream$($LF)",
                    $EncodedFile,
                    "--$($Boundary)--$($LF)"
                ) -join $LF

                $URI = "/vco/api/resources?categoryId=$($CategoryId)"

                # --- Set custom headers for the request
                $Headers = @{

                    "Authorization" = "Basic $($Script:vROConnection.EncodedPassword)";
                    "Accept" = "Application/json"
                    "Accept-Encoding" = "gzip,deflate,sdch";
                    "Content-Type" = "multipart/form-data; boundary=$($Boundary)"
                }

                if ($PSCmdlet.ShouldProcess($FileInfo.FullName)){

                    # --- Run vRO REST Request
                    Invoke-vRORestMethod -Method POST -Uri $URI -Body $Form -Headers $Headers -Verbose:$VerbosePreference | Out-Null

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
